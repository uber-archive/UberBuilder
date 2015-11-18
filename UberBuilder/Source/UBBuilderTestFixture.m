//
//  UBBuilderTestFixture.m
//  UberBuilder
//
//  Copyright (c) 2015 Uber Technologies, Inc. All rights reserved.
//

#import <UberBuilder/UBBuilderTestFixture.h>

@implementation UBBuilderTestFixture

+ (void (^)(NSInvocation *))configureBuilderInvocationAndInvokeHandler:(id)object
{
    return ^(NSInvocation *invocation) {
        __unsafe_unretained void(^handler)(id);
        [invocation getArgument:&handler atIndex:2];
        
        if (handler) {
            handler(object);
        }
        
        id returnValue = object;
        [invocation setReturnValue:&returnValue];
    };
}

@end
