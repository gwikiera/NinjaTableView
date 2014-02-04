//
//  NGGenericSurrogate.h
//  NinjaTableView
//
//  Created by Krzysztof Profic on 04/02/14.
//  Copyright (c) 2014 Wojtek Nagrodzki. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NGNinjaTableView;

@interface NGNinjaTableViewGenericSurrogate : NSProxy
@property (weak, nonatomic) NGNinjaTableView * ninjaTableView;
@property (weak, nonatomic) id proxiedObject;

- (instancetype)initWithProxiedObject:(id)proxiedObject;
@end
