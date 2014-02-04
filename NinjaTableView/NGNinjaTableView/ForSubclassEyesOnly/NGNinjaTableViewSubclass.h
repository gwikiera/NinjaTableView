//
//  NGNinjaTableViewPrivate.h
//  NinjaTableView
//
//  Created by Krzysztof Profic on 19/09/2013.
//  Copyright (c) 2013 Krzysztof Profic. All rights reserved.
//

@class NGNinjaTableViewDataSourceSurrogate;
@class NGNinjaTableViewDelegateSurrogate;

@interface NGNinjaTableView(ForSubclassEyesOnly)

@property (strong, nonatomic) NSMutableDictionary * cellData;
@property (strong, nonatomic) NGNinjaTableViewDataSourceSurrogate * dataSourceSurrogate;
@property (strong, nonatomic) NGNinjaTableViewDelegateSurrogate * delegateSurrogate;

@end
