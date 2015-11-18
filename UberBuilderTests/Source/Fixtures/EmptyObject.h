//
//  EmptyObject.h
//  UberBuilder
//
//  Copyright (c) 2015 Uber Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EmptyObject <NSObject>

@end

@protocol EmptyObjectBuilder <NSObject>

@end

@interface EmptyObject : NSObject <EmptyObject>

+ (instancetype)build:(void (^)(id <EmptyObjectBuilder>))builder;

@end
