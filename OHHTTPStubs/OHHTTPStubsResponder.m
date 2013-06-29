//
//  OHHTTPStubsResponder.m
//  OHHTTPStubs
//
//  Created by Heath Borders on 6/29/13.
//  Copyright (c) 2013 AliSoftware. All rights reserved.
//

#import "OHHTTPStubsResponder.h"
#import "OHHTTPStubsResponder+Protected.h"

@interface OHHTTPStubsResponder ()

@property (atomic) BOOL sentResponse;

@end

@implementation OHHTTPStubsResponder

#pragma mark - init/dealloc

- (id)initWithProtocol:(NSURLProtocol *)protocol
                client:(id<NSURLProtocolClient>)client
              response:(NSURLResponse *)response
                  data:(NSData *)data {
    self = [super init];
    if (self) {
        self.protocol = protocol;
        self.client = client;
        self.response = response;
        self.data = data;
    }
    return self;
}

- (void)dealloc {
    self.protocol = nil;
    self.client = nil;
    self.response = nil;
    self.data = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

#pragma mark - public API

- (void)sendResponse {
    NSAssert(self.sentResponse == NO, @"Can't send response twice");
    self.sentResponse = YES;
    [self.client URLProtocol:self.protocol
          didReceiveResponse:self.response
          cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)sendFactorOfRemainingData:(double)dataFactor {
    if (!self.sentResponse) {
        [self sendResponse];
    }
    NSUInteger sendDataLength = [self.data length] * dataFactor;
    if (sendDataLength) {
        NSData *sendData = [self.data subdataWithRange:NSMakeRange(0,
                                                                   sendDataLength)];
        self.data = [self.data subdataWithRange:NSMakeRange(sendDataLength,
                                                            [self.data length] - sendDataLength)];
        [self.client URLProtocol:self.protocol
                     didLoadData:sendData];
    }
}

- (void)finish {
    [self finishWithBlock:^{
        [self.client URLProtocolDidFinishLoading:self.protocol];
    }];
}

- (void)finishWithError:(NSError *)error {
    [self finishWithBlock:^{
        [self.client URLProtocol:self.protocol
                didFailWithError:error];
    }];
}

#pragma mark - protected API

- (void)finishWithBlock:(dispatch_block_t)finishBlock {
    if (self.finished) {
        NSAssert(NO, @"Can't finish twice");
    } else {
        if (!self.sentResponse) {
            [self sendResponse];
        }
        [self sendFactorOfRemainingData:1];
        self.finished = YES;
        finishBlock();
        
#if ! __has_feature(objc_arc)
        self.protocol = nil;
#endif
    }
}

@end
