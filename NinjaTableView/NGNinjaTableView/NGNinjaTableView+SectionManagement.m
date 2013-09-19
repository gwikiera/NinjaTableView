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
void *hiddenSectionsIndexSetKey = &hiddenSectionsIndexSetKey;

@interface NGNinjaTableView()
@property (nonatomic, readwrite) NSMutableIndexSet * foldedSectionsIndexSet;
@property (nonatomic, readwrite) NSMutableIndexSet * hiddenSectionsIndexSet;
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

- (void)hideSections:(NSIndexSet *)indices animated:(BOOL)animated
{
    [self.hiddenSectionsIndexSet addIndexes:indices];
    [self reloadSections:indices withRowAnimation: animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone];
}

- (void)hideSection:(NSInteger)section animated:(BOOL)animated
{
    [self hideSections:[NSIndexSet indexSetWithIndex:section] animated:animated];
}

- (void)showSections:(NSIndexSet *)indices animated:(BOOL)animated
{
    [self.hiddenSectionsIndexSet removeIndexes:indices];
    [self reloadSections:indices withRowAnimation: animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone];
}

- (void)showSection:(NSInteger)section animated:(BOOL)animated
{
    [self showSections:[NSIndexSet indexSetWithIndex:section] animated:animated];
}

- (void)toggleVisibilityOnSection:(NSInteger)section
{
    if ([self isSectionHidden:section]){
        [self showSection:section animated:YES];
    }
    else {
        [self hideSection:section animated:YES];
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

- (NSMutableIndexSet *)hiddenSectionsIndexSet
{
    NSMutableIndexSet * indexSet = objc_getAssociatedObject(self, hiddenSectionsIndexSetKey);
    if (indexSet == nil){
        objc_setAssociatedObject(self, hiddenSectionsIndexSetKey, [NSMutableIndexSet indexSet], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        indexSet = [NSMutableIndexSet indexSet];
    }
    return indexSet;
}

#pragma mark - Private Methods

- (BOOL)isSectionFolded:(NSInteger)section
{
    return [self.foldedSectionsIndexSet containsIndex:section];
}

- (BOOL)isSectionHidden:(NSInteger)section
{
    return [self.hiddenSectionsIndexSet containsIndex:section];
}

- (BOOL)isSectionContentVisible:(NSInteger)section
{
    return !([self isSectionFolded:section] || [self isSectionHidden:section]);
}

@end


@implementation NGNinjaTableViewDelegateAndDataSourceSurrogate(SectionManagement)

#pragma mark - Overriden (UITableViewDelegate or UITableViewDataSource)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.ninjaTableView isSectionContentVisible:section] == NO) {
        return 0;
    }
    
    return [self.tableViewDataSource tableView:tableView numberOfRowsInSection:section];
}

//
// We can't require somebody to implement the following methods
// We even can not say that that the particular method is not implemented (respondsToSelector == NO)
// so it would be just forwarded to real delegate to return defaults because
// tableView will ommit what we've implemented here (respondsToSelector == NO) == no implementatio
// Because of that we should return default values, however it's nontrivial and sometimes imposible to predict them
// that's why I simply return 0, nil aso. If somebody want's to use headers or footers,
// he will most probably override those methods anyway sot that's if not too bad.
//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)] == NO) {
        return nil;
    }
    
    if ([self.ninjaTableView isSectionHidden:section] == YES) {
        return nil;
    }
    
    return [self.tableViewDelegate tableView:tableView viewForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)] == NO){
        return 0;
    }
    
    if ([self.ninjaTableView isSectionHidden:section] == YES) {
        return 0.f;
    }
    
    return [self.tableViewDelegate tableView:tableView heightForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)] == NO){
        return 0;
    }
    
    if ([self.ninjaTableView isSectionHidden:section] == YES) {
        return 0.f;
    }
    
    return [self.tableViewDelegate tableView:tableView heightForFooterInSection:section];
}

@end