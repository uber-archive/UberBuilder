//
//  BareBuildable.m
//  UberBuilder
//
//  Copyright (c) 2015 Uber Technologies, Inc. All rights reserved.
//

#import "EmptyObject.h"

#import <UberBuilder/UBBuilder.h>

@interface EmptyObject () <UBBuildable, EmptyObjectBuilder>

@end

@implementation EmptyObject

#pragma mark - UBBuilder

+ (instancetype)build:(void (^)(id <EmptyObjectBuilder>))builder
{
    return [UBBuilder build:self builder:builder];
}

@end
