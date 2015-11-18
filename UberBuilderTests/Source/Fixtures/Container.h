//
//  Container.h
//  UberBuilder
//
//  Copyright © 2015 Uber. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BlockType)();

@protocol Container <NSObject>

@property (nonatomic, readonly, copy) NSString *string;
@property (nonatomic, readonly) NSNumber *number;
@property (nonatomic, readonly, copy) NSArray *array;
@property (nonatomic, readonly, copy) BlockType block;
@property (nonatomic, readonly) UIEdgeInsets edgeInsets;

@end

@protocol ContainerBuilder <NSObject>

@property (nonatomic, copy) NSString *string;
@property (nonatomic) NSNumber *number;
@property (nonatomic, copy) NSArray *array;
@property (nonatomic, copy) BlockType block;
@property (nonatomic) UIEdgeInsets edgeInsets;

@end

@interface Container : NSObject <Container>

@property (nonatomic, readonly) BOOL didAwakeFromBuilder;

+ (instancetype)build:(void (^)(id <ContainerBuilder>))builder;
+ (instancetype)copy:(Container *)buildable builder:(void (^)(id <ContainerBuilder>))builder;

@end
