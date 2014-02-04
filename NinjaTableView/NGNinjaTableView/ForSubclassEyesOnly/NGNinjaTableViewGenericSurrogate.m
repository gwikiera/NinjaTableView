//
//  NGGenericSurrogate.m
//  NinjaTableView
//
//  Created by Krzysztof Profic on 04/02/14.
//  Copyright (c) 2014 Wojtek Nagrodzki. All rights reserved.
//

#import "NGNinjaTableViewGenericSurrogate.h"

@implementation NGNinjaTableViewGenericSurrogate

#pragma mark - Interface Methods

- (instancetype)initWithProxiedObject:(id)proxiedObject
{
    _proxiedObject = proxiedObject;
    return self;
}

#pragma mark - Overriden

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [anInvocation invokeWithTarget:self.proxiedObject];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [self.proxiedObject respondsToSelector:aSelector];
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    return [self.proxiedObject methodSignatureForSelector:selector];
}

@end
