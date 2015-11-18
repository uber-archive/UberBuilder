//
//  UBBuilderTestFixture.h
//  UberBuilder
//
//  Copyright (c) 2015 Uber Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UBBuilderTestFixture : NSObject

+ (void (^)(NSInvocation *))configureBuilderInvocationAndInvokeHandler:(id)object;

@end
