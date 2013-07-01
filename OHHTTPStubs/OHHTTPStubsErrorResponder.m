//
//  OHHTTPStubsErrorResponder.m
//  OHHTTPStubs
//
//  Created by Heath Borders on 6/29/13.
//  Copyright (c) 2013 AliSoftware. All rights reserved.
//

#import "OHHTTPStubsErrorResponder.h"
#import "OHHTTPStubsResponder+Protected.h"

@interface OHHTTPStubsErrorResponder ()

@property (nonatomic, retain) NSError *error;

@end

@implementation OHHTTPStubsErrorResponder

- (id)initWithProtocol:(NSURLProtocol *)protocol
                client:(id<NSURLProtocolClient>)client
                 error:(NSError *)error {
    self = [super initWithProtocol:protocol
                            client:client
                          response:nil
                              data:nil];
    if (self) {
        self.error = error;
    }
    return self;
}

- (void)dealloc {
    self.error = nil;
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

#pragma mark - OHHTTPStubsResponder

- (void)validatedSendResponse {
    // nothing to do here. Don't send a response. Fail early.
}

- (void)validatedSendData:(NSData *)sendData {
    // no data to send
}

- (void)finish {
    [self finishWithError:self.error];
}

@end
