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
@property (atomic) BOOL finished;
@property (atomic) BOOL stopped;

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
    if (self.stopped) {
        NSAssert(NO, @"Can't send response when stopped");
    } else if (self.sentResponse) {
        NSAssert(NO, @"Can't send response twice");
    } else {
        self.sentResponse = YES;
        [self validatedSendResponse];
    }
}

- (void)sendFactorOfRemainingData:(double)dataFactor {
    if (self.stopped) {
        NSAssert(NO, @"Can't send data when stopped");
    } else {
        [self sendResponseIfNecessary];
        NSUInteger sendDataLength = [self.data length] * dataFactor;
        if (sendDataLength) {
            NSData *sendData = [self.data subdataWithRange:NSMakeRange(0,
                                                                       sendDataLength)];
            self.data = [self.data subdataWithRange:NSMakeRange(sendDataLength,
                                                                [self.data length] - sendDataLength)];
            [self validatedSendData:sendData];
        }
    }
}

- (void)sendRemainingData {
    [self sendFactorOfRemainingData:1];
}

- (void)finish {
    [self finishWithValidatedFinishBlock:^{
        [self sendRemainingData];
        [self.client URLProtocolDidFinishLoading:self.protocol];
    }];
}

- (void)finishWithError:(NSError *)error {
    [self finishWithValidatedFinishBlock:^{
        [self.client URLProtocol:self.protocol
                didFailWithError:error];
    }];
}

#pragma mark - protected API

- (void)validatedSendResponse {
    [self.client URLProtocol:self.protocol
          didReceiveResponse:self.response
          cacheStoragePolicy:NSURLCacheStorageAllowed];
}

- (void)validatedSendData:(NSData *)sendData {
    [self.client URLProtocol:self.protocol
                 didLoadData:sendData];
}

- (void)finishWithValidatedFinishBlock:(dispatch_block_t)validatedFinishBlock {
    if (self.stopped) {
        NSAssert(NO, @"Can't finish when stopped");
    } else if (self.finished) {
        NSAssert(NO, @"Can't finish twice");
    } else {
        self.finished = YES;
        validatedFinishBlock();
        
#if ! __has_feature(objc_arc)
        self.protocol = nil;
#endif
    }
}

- (void)stopLoading {
    self.stopped = YES;
}

#pragma mark - private API

- (void)sendResponseIfNecessary {
    if (!self.sentResponse) {
        [self sendResponse];
    }
}

@end
