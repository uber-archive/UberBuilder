//
//  ModifiedContainer.h
//  UberBuilder
//
//  Copyright (c) 2015 Uber Technologies, Inc. All rights reserved.
//

#import "Container.h"

@protocol ModifiedContainer <Container>

@property (nonatomic, readonly) BOOL flag;

@end

@protocol ModifiedContainerBuilder <ContainerBuilder>

@property (nonatomic) BOOL flag;

@end

@interface ModifiedContainer : Container <ModifiedContainer>

+ (instancetype)build:(void (^)(id <ModifiedContainerBuilder>))builder;
+ (instancetype)copy:(Container *)buildable builder:(void (^)(id <ModifiedContainerBuilder>))builder;

@end
