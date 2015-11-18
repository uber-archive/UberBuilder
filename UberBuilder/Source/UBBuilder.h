//
//  UBBuilder.h
//  UberBuilder
//
//  Copyright © 2015 Uber. All rights reserved.
//

/**
 UberBuilder is a set of macros provided to make building flexible, immutable objects a simple task.
 */

#import <Foundation/Foundation.h>

/**
 The UBBuilder protocol provides an optional interface that buildable objects can conform to be callend on buildable lifecycle events.
 */
@protocol UBBuildable <NSObject>

@optional
/**
 This optional method provides a post-build hook that is called after buildable creation.
 */
- (void)ub_awakeFromBuilder;

@end

@interface UBBuilder : NSObject

/**
 This method is used to build a buildable instance.
 
 @param class Must conform to UBBuildable protocol.  An instance of this class will be built and returned.
 @param builder This block parameters passes back an instance of the buildable object exposing setter properties.
 */
+ (id)build:(Class)class builder:(void (^)(id))builder;

/**
 This method is used to build a copy of a buildable instance.
 
 @param object An object conforming to the UBBuildable protocol that will be copied.
 @param class The class of the object to instantiate when copying.  This must conform to the UBBuildable protocol.
 @param builderProtocol The protocol that exposes the mutable builder properties of the buildable..
 @param builder This block parameters passes back an instance of the buildable object exposing setter properties that can be altered after the copy action.
 */
+ (id)copy:(id)object class:(Class)klass builderProtocol:(Protocol *)builderProtocol builder:(void (^)(id))builder;

@end
