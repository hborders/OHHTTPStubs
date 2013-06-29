//
//  OHHTTPStubsErrorResponder.h
//  OHHTTPStubs
//
//  Created by Heath Borders on 6/29/13.
//  Copyright (c) 2013 AliSoftware. All rights reserved.
//

#import "OHHTTPStubsResponder.h"

@interface OHHTTPStubsErrorResponder : OHHTTPStubsResponder

- (id)initWithProtocol:(NSURLProtocol *)protocol
                client:(id<NSURLProtocolClient>)client
                 error:(NSError *)error;

@end
