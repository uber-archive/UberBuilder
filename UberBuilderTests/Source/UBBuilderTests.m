//
//  UBBuilderTests.m
//  UberBuilder
//
//  Copyright © 2015 Uber. All rights reserved.
//

#import "EmptyObject.h"
#import "Container.h"
#import "ModifiedContainer.h"

#import <UberBuilder/UBBuilder.h>

#import <XCTest/XCTest.h>

@interface Container ()

@property (nonatomic) BOOL didAwakeFromBuilder;

@end

@interface UBBuilderTests : XCTestCase

@end

@implementation UBBuilderTests

- (void)testAssignObject
{
    NSNumber *testNumber = @5;
    
    Container *buildable = [Container build:^(id <ContainerBuilder> builder) {
        builder.number = testNumber;
    }];
    
    XCTAssertEqualObjects(buildable.number, testNumber);
    XCTAssertEqual(buildable.number, testNumber);
}

- (void)testCopyObject
{
    NSMutableString *testString = [@"Test" mutableCopy];
    
    Container *buildable = [Container build:^(id <ContainerBuilder> builder) {
        builder.string = testString;
    }];
    [testString appendString:@" String"];
    
    XCTAssertEqualObjects(buildable.string, @"Test");
}

- (void)testAssignPrimitive
{
    UIEdgeInsets testEdgeInsets = UIEdgeInsetsMake(0.0, 1.0, 1.0, 2.0);
    
    Container *buildable = [Container build:^(id <ContainerBuilder> builder) {
        builder.edgeInsets = testEdgeInsets;
    }];
    
    XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(buildable.edgeInsets, testEdgeInsets));
}

- (void)testCopyBlock
{
    BlockType testBlock = ^{};
    
    Container *buildable = [Container build:^(id <ContainerBuilder> builder) {
        builder.block = testBlock;
    }];
    
    XCTAssertEqualObjects(buildable.block, testBlock);
}

- (void)testDefaultValue
{
    Container *buildable = [Container build:nil];
    
    XCTAssertEqualObjects(buildable.array, @[]);
}

- (void)testNilValue
{
    Container *buildable = [Container build:^(id <ContainerBuilder> builder) {
        builder.array = nil;
    }];
    
    XCTAssertNil(buildable.array);
}

- (void)testCopyBuildable
{
    Container *buildable = [Container build:^(id <ContainerBuilder> builder) {
        builder.string = @"Test";
        builder.number = @237;
        builder.block = ^{};
        builder.edgeInsets = UIEdgeInsetsMake(0.0, 1.0, 2.0, 3.0);
    }];
    
    Container *buildableCopy = [Container copy:buildable builder:nil];
    
    XCTAssertEqualObjects(buildable.string, buildableCopy.string);
    XCTAssertEqualObjects(buildable.number, buildableCopy.number);
    XCTAssertEqualObjects(buildable.array, buildableCopy.array);
    XCTAssertEqualObjects(buildable.block, buildableCopy.block);
    XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(buildable.edgeInsets, buildableCopy.edgeInsets));
    XCTAssertTrue(buildableCopy.didAwakeFromBuilder);
}

- (void)testDidAwakeFromBuilder
{
    Container *buildable = [Container build:nil];
    XCTAssertTrue(buildable.didAwakeFromBuilder);
}

- (void)testEmptyObjectBuilds
{
    EmptyObject *buildable = [EmptyObject build:nil];
    XCTAssert(buildable);
}

- (void)testCopyDerivedObject
{
    ModifiedContainer *buildable = [ModifiedContainer build:^(id <ModifiedContainerBuilder> builder) {
        builder.string = @"Test";
        builder.number = @237;
        builder.block = ^{};
        builder.edgeInsets = UIEdgeInsetsMake(0.0, 1.0, 2.0, 3.0);
        builder.flag = YES;
    }];
    
    ModifiedContainer *buildableCopy = [ModifiedContainer copy:buildable builder:nil];
    
    XCTAssertEqualObjects(buildable.string, buildableCopy.string);
    XCTAssertEqualObjects(buildable.number, buildableCopy.number);
    XCTAssertEqualObjects(buildable.array, buildableCopy.array);
    XCTAssertEqualObjects(buildable.block, buildableCopy.block);
    XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(buildable.edgeInsets, buildableCopy.edgeInsets));
    XCTAssertEqual(buildable.flag, buildableCopy.flag);
    XCTAssertTrue(buildableCopy.didAwakeFromBuilder);
}

- (void)testCopyDerivedObjectFromBaseObject
{
    Container *buildable = [Container build:^(id <ContainerBuilder> builder) {
        builder.string = @"Test";
        builder.number = @237;
        builder.block = ^{};
        builder.edgeInsets = UIEdgeInsetsMake(0.0, 1.0, 2.0, 3.0);
    }];
    
    ModifiedContainer *buildableCopy = [ModifiedContainer copy:buildable builder:nil];
    
    XCTAssertEqualObjects(buildable.string, buildableCopy.string);
    XCTAssertEqualObjects(buildable.number, buildableCopy.number);
    XCTAssertEqualObjects(buildable.array, buildableCopy.array);
    XCTAssertEqualObjects(buildable.block, buildableCopy.block);
    XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(buildable.edgeInsets, buildableCopy.edgeInsets));
    XCTAssertFalse(buildableCopy.flag);
    XCTAssertTrue(buildableCopy.didAwakeFromBuilder);
}

- (void)testCopyBaseObjectFromDerivedObject
{
    ModifiedContainer *buildable = [ModifiedContainer build:^(id <ModifiedContainerBuilder> builder) {
        builder.string = @"Test";
        builder.number = @237;
        builder.block = ^{};
        builder.edgeInsets = UIEdgeInsetsMake(0.0, 1.0, 2.0, 3.0);
        builder.flag = YES;
    }];
    
    Container *buildableCopy = [Container copy:buildable builder:nil];
    
    XCTAssertEqualObjects(buildable.string, buildableCopy.string);
    XCTAssertEqualObjects(buildable.number, buildableCopy.number);
    XCTAssertEqualObjects(buildable.array, buildableCopy.array);
    XCTAssertEqualObjects(buildable.block, buildableCopy.block);
    XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(buildable.edgeInsets, buildableCopy.edgeInsets));
    XCTAssertTrue(buildableCopy.didAwakeFromBuilder);
}

@end
