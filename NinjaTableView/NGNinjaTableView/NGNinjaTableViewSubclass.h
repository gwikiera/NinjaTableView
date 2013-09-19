//
//  NGNinjaTableViewPrivate.h
//  NinjaTableView
//
//  Created by Krzysztof Profic on 19/09/2013.
//  Copyright (c) 2013 Krzysztof Profic. All rights reserved.
//


@interface NGNinjaTableViewDelegateAndDataSourceSurrogate(ForSubclassingEyesOnly)

@property (weak, nonatomic) NSObject<UITableViewDelegate>* tableViewDelegate;
@property (weak, nonatomic) NSObject<UITableViewDataSource>* tableViewDataSource;
@property (weak, nonatomic) NGNinjaTableView * ninjaTableView;

@end


@interface NGNinjaTableView(ForSubclassingEyesOnly)

@property (strong, nonatomic) NSMutableDictionary * cellData;
@property (strong, nonatomic) NGNinjaTableViewDelegateAndDataSourceSurrogate * delegateAndDataSourceSurrogate;

@end
