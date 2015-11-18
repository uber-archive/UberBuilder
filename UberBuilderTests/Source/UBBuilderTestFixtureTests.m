//
//  UBBuilderTestFixtureTests.m
//  UberBuilder
//
//  Copyright (c) 2015 Uber Technologies, Inc. All rights reserved.
//

#import "Container.h"

#import <OCMock/OCMock.h>
#import <UberBuilder/UberBuilder.h>

#import <XCTest/XCTest.h>

@interface UBBuilderTestFixtureTests : XCTestCase

@end

@implementation UBBuilderTestFixtureTests

- (void)testBuildCallsHandler_withCorrectArguments
{
    id containerMock = OCMClassMock([Container class]);
    OCMStub([containerMock build:[OCMArg any]]).andDo([UBBuilderTestFixture configureBuilderInvocationAndInvokeHandler:containerMock]);
    
    __block id <ContainerBuilder> recoveredBuilder;
    [Container build:^(id <ContainerBuilder> builder) {
        recoveredBuilder = builder;
    }];
    
    XCTAssertEqual(recoveredBuilder, containerMock);
    
    [containerMock stopMocking];
}

- (void)testBuildReturnsBuildable
{
    id containerMock = OCMClassMock([Container class]);
    OCMStub([containerMock build:[OCMArg any]]).andDo([UBBuilderTestFixture configureBuilderInvocationAndInvokeHandler:containerMock]);
    
    Container *container = [Container build:nil];
    
    XCTAssertEqual(container, containerMock);
    
    [containerMock stopMocking];
}

@end
