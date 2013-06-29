//
//  OHHTTPStubsResponder+Protected.h
//  OHHTTPStubs
//
//  Created by Heath Borders on 6/29/13.
//  Copyright (c) 2013 AliSoftware. All rights reserved.
//

#import "OHHTTPStubsResponder.h"

@interface OHHTTPStubsResponder ()

// atomic for memory safety, not necessarily thread-safety
@property (atomic, assign) NSURLProtocol *protocol;
@property (atomic, retain) id<NSURLProtocolClient> client;
@property (atomic, retain) NSURLResponse *response;
@property (atomic, retain) NSData *data;
@property (atomic) BOOL finished;

- (id)initWithProtocol:(NSURLProtocol *)protocol
                client:(id<NSURLProtocolClient>)client
              response:(NSURLResponse *)response
                  data:(NSData *)data;

- (void)finishWithBlock:(dispatch_block_t)finishBlock;

@end
