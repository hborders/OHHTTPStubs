//
//  OHHTTPStubsResponder.h
//  OHHTTPStubs
//
//  Created by Heath Borders on 6/29/13.
//  Copyright (c) 2013 AliSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHHTTPStubsResponder : NSObject

- (void)sendResponse;
- (void)sendFactorOfRemainingData:(double)dataFactor;
- (void)sendRemainingData;
- (void)finish;
- (void)finishWithError:(NSError *)error;

@end
