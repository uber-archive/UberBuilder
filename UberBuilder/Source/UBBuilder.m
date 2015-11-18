//
//  UBBuilder.m
//  UberBuilder
//
//  Copyright © 2015 Uber. All rights reserved.
//

#import <UberBuilder/UBBuilder.h>

#import <objc/runtime.h>

@implementation UBBuilder

#pragma mark - Build

+ (id)build:(Class)class builder:(void (^)(id))builder
{
    id <UBBuildable> result = [[class alloc] init];
    
    if (builder) {
        builder(result);
    }
    
    if ([result respondsToSelector:@selector(ub_awakeFromBuilder)]) {
        [result ub_awakeFromBuilder];
    }
    
    return result;
}

#pragma mark - Copy

+ (id)copy:(id)object class:(Class)klass builderProtocol:(Protocol *)protocol builder:(void (^)(id))builder
{
    id result = [[klass alloc] init];
    
    NSArray *propertyNames = [self propertyNamesForProtocolGraph:protocol];
    for (NSString *propertyName in propertyNames) {
        NSMutableString *setterSelectorString = [@"set" mutableCopy];
        [setterSelectorString appendString:[[propertyName substringToIndex:1] capitalizedString]];
        if (propertyName.length > 1) {
            [setterSelectorString appendString:[propertyName substringFromIndex:1]];
        }
        [setterSelectorString appendString:@":"];
        if ([object respondsToSelector:NSSelectorFromString(setterSelectorString)]) {
            [result setValue:[object valueForKey:propertyName] forKey:propertyName];
        }
    }
    
    if (builder) {
        builder(result);
    }

    if ([result respondsToSelector:@selector(ub_awakeFromBuilder)]) {
        [result ub_awakeFromBuilder];
    }

    return result;
}

+ (NSArray *)propertyNamesForProtocolGraph:(Protocol *)protocol
{
    unsigned int count;
    Protocol * __unsafe_unretained *protocols = protocol_copyProtocolList(protocol, &count);
    
    NSMutableArray *propertyNames = [NSMutableArray array];
    [propertyNames addObjectsFromArray:[self propertyNamesForProtocol:protocol]];
    for (unsigned int i = 0; i < count; i++) {
        Protocol *protocol = protocols[i];
        if (protocol != @protocol(NSObject)) {
            [propertyNames addObjectsFromArray:[self propertyNamesForProtocol:protocol]];
        }
    }
    
    free(protocols);
    
    return [propertyNames copy];
}

+ (NSArray *)propertyNamesForProtocol:(Protocol *)protocol
{
    unsigned int count;
    objc_property_t *properties = protocol_copyPropertyList(protocol, &count);
    
    NSMutableArray *propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [propertyNames addObject:name];
    }
    free(properties);
    
    return [propertyNames copy];
}

@end
