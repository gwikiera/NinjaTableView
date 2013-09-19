//
//  NGNinjaTableView+SectionManagement.m
//  NinjaTableView
//
//  Created by Krzysztof Profic on 19/09/2013.
//  Copyright (c) 2013 Krzysztof Profic. All rights reserved.
//

#import "NGNinjaTableView+SectionManagement.h"
#import "NGNinjaTableViewSubclass.h"
#import <objc/runtime.h>

void *foldedSectionsIndexSetKey = &foldedSectionsIndexSetKey;

@interface NGNinjaTableView()
@property (nonatomic, readwrite) NSMutableIndexSet * foldedSectionsIndexSet;
@end

@implementation NGNinjaTableView (SectionManagement)

#pragma mark - Interface Methods

- (void)foldSections:(NSIndexSet *)indices animated:(BOOL)animated
{
    [self.foldedSectionsIndexSet addIndexes:indices];
    [self reloadSections:indices withRowAnimation: animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone];
}

- (void)foldSection:(NSInteger)section animated:(BOOL)animated
{
    [self foldSections:[NSIndexSet indexSetWithIndex:section] animated:animated];
}

- (void)unfoldSections:(NSIndexSet *)indices animated:(BOOL)animated
{
    [self.foldedSectionsIndexSet removeIndexes:indices];
    [self reloadSections:indices withRowAnimation: animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone];
}

- (void)unfoldSection:(NSInteger)section animated:(BOOL)animated
{
    [self unfoldSections:[NSIndexSet indexSetWithIndex:section] animated:animated];
}

- (void)toggleFoldingOnSection:(NSInteger)section
{
    if ([self isSectionFolded:section]){
        [self unfoldSection:section animated:YES];
    }
    else {
        [self foldSection:section animated:YES];
    }
}

#pragma mark - Interface Properties

- (NSMutableIndexSet *)foldedSectionsIndexSet
{
    NSMutableIndexSet * indexSet = objc_getAssociatedObject(self, foldedSectionsIndexSetKey);
    if (indexSet == nil){
        objc_setAssociatedObject(self, foldedSectionsIndexSetKey, [NSMutableIndexSet indexSet], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        indexSet = [NSMutableIndexSet indexSet];
    }
    return indexSet;
}

#pragma mark - Private Methods

- (BOOL)isSectionFolded:(NSInteger)section
{
    return [self.foldedSectionsIndexSet containsIndex:section];
}

@end


@implementation NGNinjaTableViewDelegateAndDataSourceSurrogate(SectionManagement)

#pragma mark - Overriden (UITableViewDelegate or UITableViewDataSource)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.ninjaTableView.foldedSectionsIndexSet containsIndex:section] == YES) {
        return 0;
    }
    
    return [self.tableViewDataSource tableView:tableView numberOfRowsInSection:section];
}

@end