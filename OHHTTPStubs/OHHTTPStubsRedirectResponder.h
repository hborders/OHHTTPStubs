//
//  OHHTTPStubsRedirectResponder.h
//  OHHTTPStubs
//
//  Created by Heath Borders on 6/29/13.
//  Copyright (c) 2013 AliSoftware. All rights reserved.
//

#import "OHHTTPStubsResponder.h"

@interface OHHTTPStubsRedirectResponder : OHHTTPStubsResponder

- (id)initWithProtocol:(NSURLProtocol *)protocol
                client:(id<NSURLProtocolClient>)client
              response:(NSURLResponse *)response
       redirectRequest:(NSURLRequest *)redirectRequest;

@end
