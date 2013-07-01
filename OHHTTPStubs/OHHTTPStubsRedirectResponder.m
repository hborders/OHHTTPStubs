//
//  OHHTTPStubsRedirectResponder.m
//  OHHTTPStubs
//
//  Created by Heath Borders on 6/29/13.
//  Copyright (c) 2013 AliSoftware. All rights reserved.
//

#import "OHHTTPStubsRedirectResponder.h"
#import "OHHTTPStubsResponder+Protected.h"

@interface OHHTTPStubsRedirectResponder ()

@property (nonatomic, retain) NSURLRequest *redirectRequest;

@end

@implementation OHHTTPStubsRedirectResponder

#pragma mark - init/dealloc

- (id)initWithProtocol:(NSURLProtocol *)protocol
                client:(id<NSURLProtocolClient>)client
              response:(NSURLResponse *)response
       redirectRequest:(NSURLRequest *)redirectRequest {
    self = [super initWithProtocol:protocol
                            client:client
                          response:response
                              data:nil];
    if (self) {
        self.redirectRequest = redirectRequest;
    }
    return self;
}

- (void)dealloc {
    self.redirectRequest = nil;
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

#pragma mark - OHHTTPStubsResponder

- (void)validatedSendResponse {
    // nothing to do here. will send the redirect in finish.
}

- (void)validatedSendData:(NSData *)sendData {
    // no data to send
}

- (void)finish {
    [self finishWithValidatedFinishBlock:^{
        [self.client URLProtocol:self.protocol
          wasRedirectedToRequest:self.redirectRequest
                redirectResponse:self.response];
    }];
}

@end
