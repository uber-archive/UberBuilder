//
//  Buildable.m
//  UberBuilder
//
//  Copyright © 2015 Uber. All rights reserved.
//

#import "Container.h"

#import <UberBuilder/UBBuilder.h>

@interface Container () <UBBuildable, ContainerBuilder>

@property (nonatomic) BOOL didAwakeFromBuilder;

@end

@implementation Container

@synthesize string = _string;
@synthesize number = _number;
@synthesize array = _array;
@synthesize block = _block;
@synthesize edgeInsets = _edgeInsets;

#pragma mark - Constructor

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.array = @[];
    }
    
    return self;
}

+ (instancetype)build:(void (^)(id <ContainerBuilder>))builder
{
    return [UBBuilder build:self builder:builder];
}

+ (instancetype)copy:(Container *)buildable builder:(void (^)(id <ContainerBuilder>))builder
{
    return [UBBuilder copy:buildable class:self builderProtocol:@protocol(ContainerBuilder) builder:builder];
}

#pragma mark - UBBuildable

- (void)ub_awakeFromBuilder
{
    self.didAwakeFromBuilder = YES;
}

@end
