//
//  DerivedBuildable.m
//  UberBuilder
//
//  Copyright (c) 2015 Uber Technologies, Inc. All rights reserved.
//

#import "ModifiedContainer.h"

#import <UberBuilder/UBBuilder.h>

@interface ModifiedContainer () <UBBuildable, ModifiedContainerBuilder>

@end

@implementation ModifiedContainer

@synthesize flag = _flag;

#pragma mark - UBBuilder

+ (instancetype)build:(void (^)(id <ModifiedContainerBuilder>))builder
{
    return [UBBuilder build:self builder:builder];
}

+ (instancetype)copy:(ModifiedContainer *)buildable builder:(void (^)(id <ModifiedContainerBuilder>))builder
{
    return [UBBuilder copy:buildable class:self builderProtocol:@protocol(ModifiedContainerBuilder) builder:builder];
}

@end
