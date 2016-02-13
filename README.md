UberBuilder
=====

What is UberBuilder?
--------------
UberBuilder is a set of convenience methods provided to make building flexible, immutable objects a simple task.

## Requirements

- iOS 7.0+ / Mac OS X 10.10+
- Xcode 6.0
- CocoaPods 0.37.1

## CocoaPods Installation

1. Add UberBuilder as a line in your Podfile `pod 'UberBuilder/Core', '~> 1.0'`
2. Run `pod install`
3. Add `#import <UberBuilder/UBBuilder.h>` to the file(s) that you wish the use it in.

# Usage

Below we define a **buildable** `Container` class with readonly properties that is intended to be created via the `[Container build:]` method.

```objective-c
// Container.h

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
```
It is important to note that the `Container` class conforms publicly to the read-only `Container` protocol.  The `ContainerBuilder` protocol is exposed to allow setting of **builder** properties in the `builder` block seen in the `[Container build:]` and `[Container copy:builder:]` methods.

The implementation for the `Container` class should contain an extension to the class that conforms to the `UBBuildable` and `ContainerBuilder` protocols.  Each property from the **builder** protocol must be synthesized.

```objective-c
#import "Container.h"

#import <UberBuilder/UBBuilder.h>

@interface Container () <UBBuildable, ContainerBuilder>

@end

@implementation Container

@synthesize string = _string;
@synthesize number = _number;
@synthesize array = _array;
@synthesize block = _block;
@synthesize edgeInsets = _edgeInsets;

#pragma mark - Constructor

- (instancetype)init {
    self = [super init];
    
    if (self) {
    	 // Set default values here, if desired
        self.array = @[];
    }
    
    return self;
}

#pragma mark - UBBuilder

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
    // Take some action post-build.  For example, perform validation, ensure required parameters are set, etc...
    NSParameterAssert(self.array);
}

@end
```
The **builder** methods simply make a forwarding call to `[UBBuilder build:builder]` and `[UBBuilder copy:class:builderProtocol:builder:]` methods.

In a practical exercise below, we create a `Container` instance and have the flexibility to assign any combination of the properties that we choose.  After the object is created, there are no public mutators defined and the consumer is unable to mutate without using the runtime.

```objective-c
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
}
```