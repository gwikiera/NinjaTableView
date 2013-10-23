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
void *sectionsForHeadersKey = &sectionsForHeadersKey;
void *allowsUnfoldingOnMultipleSectionsKey = &allowsUnfoldingOnMultipleSectionsKey;

@interface CATransaction(Blocks)
+ (void)performWithTransactionBlock:(void (^)())transaction afterTransactionCommitBlock:(void (^)())afterCommit transactionCompletionBlock:(void (^)())completion;
@end

@interface NGNinjaTableView()
@property (nonatomic, readwrite) NSMutableIndexSet * foldedSectionsIndexSet;
@property (nonatomic, readwrite) NSMutableIndexSet * hiddenSectionsIndexSet;
@property (strong, nonatomic) NSMapTable * sectionsForHeaders;
@end

@implementation NGNinjaTableView (SectionManagement)

#pragma mark - Interface Methods

- (void)foldSections:(NSIndexSet *)sections animated:(BOOL)animated
{
    NSIndexSet * indices = sections;
    if ([self.delegate respondsToSelector:@selector(tableView:willStartFoldingSections:animated:)] == YES) {
        indices = [(id)self.delegate tableView:self willStartFoldingSections:sections animated:animated];
    }
    if (indices.count == 0) return;
    
    [CATransaction performWithTransactionBlock:^{
        [self.foldedSectionsIndexSet addIndexes:indices];
        [self reloadSections:indices withRowAnimation: animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone];
    } afterTransactionCommitBlock:^{
        if ([self.delegate respondsToSelector:@selector(tableView:didStartFoldingSections:animated:)] == YES){
            [(id)self.delegate tableView:self didStartFoldingSections:indices animated:animated];
        }
    } transactionCompletionBlock:^{
        if ([self.delegate respondsToSelector:@selector(tableView:didFinishFoldingSections:animated:)] == YES){
            [(id)self.delegate tableView:self didFinishFoldingSections:indices animated:animated];
        }
    }];
}

- (void)foldSection:(NSInteger)section animated:(BOOL)animated
{
    [self foldSections:[NSIndexSet indexSetWithIndex:section] animated:animated];
}

- (void)unfoldSections:(NSIndexSet *)sections animated:(BOOL)animated
{
    NSIndexSet * sectionsToUnfold = sections;
    if ([self.delegate respondsToSelector:@selector(tableView:willStartUnfoldingSections:animated:)] == YES) {
        sectionsToUnfold = [(id)self.delegate tableView:self willStartUnfoldingSections:sections animated:animated];
    }
    if (sectionsToUnfold.count == 0) return;
    
    NSIndexSet * sectionsToReload = sectionsToUnfold;
    
    // If allowsUnfoldingOnMultipleSections is set to NO unfolding may be performed only on one section
    // additinaly the sections that were unfolded before become folded in afterwards.
    // Otherwise (if allowsUnfoldingOnMultipleSections == YES) then we're just unfolding what's passed as parameter
    if (self.allowsUnfoldingOnMultipleSections == NO) {
        if ([sectionsToUnfold count] > 1) {
            [NSException raise:NSInvalidArgumentException format:@"Unfolding more than one section when allowsUnfoldingOnMultipleSections is set to NO is prohibited"];
        }
        
        // decide which sections should be reloaded
        NSIndexSet * oldFoldedSectionsIndexSet = self.foldedSectionsIndexSet;
        NSMutableIndexSet * toReload = [[self allSectionsIndexSet] mutableCopy];
        [toReload removeIndexes:oldFoldedSectionsIndexSet]; // reload also sections that were folded before (closing needs to be performed)
        [toReload addIndexes:sectionsToUnfold];             // reload the section we're unfolding
        sectionsToReload = toReload;
        
        // setup new unfolded section
        self.foldedSectionsIndexSet = [[self allSectionsIndexSet] mutableCopy];
        [self.foldedSectionsIndexSet removeIndexes:sectionsToUnfold];
    }
    else {
        [self.foldedSectionsIndexSet removeIndexes:sectionsToUnfold];
    }
    
    // perform unfolding
    [CATransaction performWithTransactionBlock:^{
        [self reloadSections:sectionsToReload withRowAnimation: animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone];
    } afterTransactionCommitBlock:^{
        if ([self.delegate respondsToSelector:@selector(tableView:didStartUnfoldingSections:animated:)] == YES){
            [(id)self.delegate tableView:self didStartUnfoldingSections:sectionsToUnfold animated:animated];
        }
    } transactionCompletionBlock:^{
        if ([self.delegate respondsToSelector:@selector(tableView:didFinishUnfoldingSections:animated:)] == YES){
            [(id)self.delegate tableView:self didFinishUnfoldingSections:sectionsToUnfold animated:animated];
        }
    }];
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

- (void)hideSections:(NSIndexSet *)sections animated:(BOOL)animated
{
    NSIndexSet * indices = sections;
    if ([self.delegate respondsToSelector:@selector(tableView:willStartHidingSections:animated:)] == YES) {
        indices = [(id)self.delegate tableView:self willStartHidingSections:sections animated:animated];
    }
    if (indices.count == 0) return;

    
    [CATransaction performWithTransactionBlock:^{
        [self.hiddenSectionsIndexSet addIndexes:indices];
        [self reloadSections:indices withRowAnimation: animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone];
    } afterTransactionCommitBlock:^{
        if ([self.delegate respondsToSelector:@selector(tableView:didStartHidingSections:animated:)] == YES) {
            [(id)self.delegate tableView:self didStartHidingSections:indices animated:animated];
        }
    } transactionCompletionBlock:^{
        if ([self.delegate respondsToSelector:@selector(tableView:didFinishHidingSections:animated:)] == YES) {
            [(id)self.delegate tableView:self didStartHidingSections:indices animated:animated];
        }
    }];
}

- (void)hideSection:(NSInteger)section animated:(BOOL)animated
{
    [self hideSections:[NSIndexSet indexSetWithIndex:section] animated:animated];
}

- (void)showSections:(NSIndexSet *)sections animated:(BOOL)animated
{
    NSIndexSet * indices = sections;
    if ([self.delegate respondsToSelector:@selector(tableView:willStartShowingSections:animated:)] == YES) {
        indices = [(id)self.delegate tableView:self willStartShowingSections:indices animated:animated];
    }
    if (indices.count == 0) return;
    
    [CATransaction performWithTransactionBlock:^{
        [self.hiddenSectionsIndexSet removeIndexes:indices];
        [self reloadSections:indices withRowAnimation: animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone];
    } afterTransactionCommitBlock:^{
        if ([self.delegate respondsToSelector:@selector(tableView:didStartShowingSections:animated:)] == YES) {
            [(id)self.delegate tableView:self didStartShowingSections:indices animated:animated];
        }
    } transactionCompletionBlock:^{
        if ([self.delegate respondsToSelector:@selector(tableView:didFinishShowingSections:animated:)] == YES) {
            [(id)self.delegate tableView:self didFinishShowingSections:indices animated:animated];
        }
    }];
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

- (BOOL)isSectionFolded:(NSInteger)section
{
    return [self.foldedSectionsIndexSet containsIndex:section];
}

- (BOOL)isSectionHidden:(NSInteger)section
{
    return [self.hiddenSectionsIndexSet containsIndex:section];
}

- (NSInteger)sectionForHeaderView:(UIView *)headerView
{
    NSNumber * section = [self.sectionsForHeaders objectForKey:headerView];
    if (section == nil)
        return NSNotFound;
    
    return section.integerValue;
}

/**
	We should consider moving this method to NGNinjaTableView itself, maybe hidden under some "auto vertical centering" mode
 */
- (CGFloat)emptyContentHeight
{
    CGFloat height = self.bounds.size.height;
    height -= self.tableHeaderView.bounds.size.height;
    height -= self.tableFooterView.bounds.size.height;
    
    // section headers
    NSInteger sectionsCount = [self.dataSource numberOfSectionsInTableView:self];
    if ([self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)] == YES) {
        for (int i = 0; i < sectionsCount; i++) {
            height -= [self.delegate tableView:self heightForHeaderInSection:i];
            if (height <= 0) return 0;
        }
    }
    else {
        height -= (20.0f*sectionsCount); // default header height used (20)
    }
    
    // section footers
    if ([self.delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)] == YES) {
        for (int i = 0; i < sectionsCount; i++) {
            height -= [self.delegate tableView:self heightForFooterInSection:i];
            if (height <= 0) return 0;
        }
    }
    else {
        height -= (20.0f*sectionsCount); // default footer height used (20)
    }
    
    // rows
    for (int i = 0; i < sectionsCount; i++) {
        NSInteger rowsCount = [self.dataSource tableView:self numberOfRowsInSection:i];
        if ([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)] == YES) {
            for (int j = 0; j < rowsCount; j++) {
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                height -= [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
                if (height <= 0) return 0;
            }
        }
        else {
            height -= (44.0f*rowsCount);
            if (height <= 0) return 0;
        }
    }
    
    return MAX(height, 0);
}

#pragma mark - Interface Properties

- (NSMutableIndexSet *)foldedSectionsIndexSet
{
    NSMutableIndexSet * indexSet = objc_getAssociatedObject(self, foldedSectionsIndexSetKey);
    if (indexSet == nil){
        indexSet = [NSMutableIndexSet indexSet];
        objc_setAssociatedObject(self, foldedSectionsIndexSetKey, indexSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [indexSet copy];
}

- (void)setFoldedSectionsIndexSet:(NSMutableIndexSet *)foldedSectionsIndexSet
{
    objc_setAssociatedObject(self, foldedSectionsIndexSetKey, foldedSectionsIndexSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableIndexSet *)hiddenSectionsIndexSet
{
    NSMutableIndexSet * indexSet = objc_getAssociatedObject(self, hiddenSectionsIndexSetKey);
    if (indexSet == nil){
        indexSet = [NSMutableIndexSet indexSet];
        objc_setAssociatedObject(self, hiddenSectionsIndexSetKey, indexSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [indexSet copy];
}

- (BOOL)allowsUnfoldingOnMultipleSections
{
    NSNumber * value = objc_getAssociatedObject(self, allowsUnfoldingOnMultipleSectionsKey);
    if (value == nil) {
        value = @(YES);
        objc_setAssociatedObject(self, allowsUnfoldingOnMultipleSectionsKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [value boolValue];
}

- (void)setAllowsUnfoldingOnMultipleSections:(BOOL)allowsUnfoldingOnMultipleSections
{
    if (allowsUnfoldingOnMultipleSections == self.allowsUnfoldingOnMultipleSections) return;
    
    NSNumber * value = @(allowsUnfoldingOnMultipleSections);
    objc_setAssociatedObject(self, allowsUnfoldingOnMultipleSectionsKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (allowsUnfoldingOnMultipleSections == NO) {
        // close all sections by default
        [self foldSections:[self allSectionsIndexSet] animated:NO];
    }
}

#pragma mark - Private Properties

- (NSMapTable *)sectionsForHeaders
{
    NSMapTable * sectionsForHeaders = objc_getAssociatedObject(self, sectionsForHeadersKey);
    if (sectionsForHeaders == nil) {
        sectionsForHeaders = [NSMapTable weakToStrongObjectsMapTable];
        objc_setAssociatedObject(self, sectionsForHeadersKey, sectionsForHeaders, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return sectionsForHeaders;
}

#pragma mark - Private Methods

- (NSIndexSet *)allSectionsIndexSet
{
    NSInteger sections = [self.delegateAndDataSourceSurrogate.tableViewDataSource numberOfSectionsInTableView:self];
    NSIndexSet * set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, sections)];
    return set;
}

- (BOOL)isSectionContentVisible:(NSInteger)section
{
    return !([self isSectionFolded:section] || [self isSectionHidden:section]);
}

- (void)registerHeaderView:(UIView *)headerView forSection:(NSInteger)section
{
    [self.sectionsForHeaders setObject:@(section) forKey:headerView];
}

- (void)unregisterHeaderView:(UIView *)headerView fromSection:(NSInteger)section
{
    [self.sectionsForHeaders removeObjectForKey:headerView];
}

@end


@implementation NGNinjaTableViewDelegateAndDataSourceSurrogate(SectionManagement)

#pragma mark - Overriden (UITableViewDelegate or UITableViewDataSource)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.ninjaTableView isSectionFolded:section] == YES && [self.ninjaTableView isSectionHidden:section] == NO) {
        if ([self.tableViewDataSource respondsToSelector:@selector(tableView:numberOfRowsInSectionWhenFolded:)] == YES) {
            return [(id)self.tableViewDataSource tableView:self.ninjaTableView numberOfRowsInSectionWhenFolded:section];
        }
    }
    
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
    
    // The reason headeView is registered here is that UITableView does not call -tableView:willDisplayHeaderView:forSection:
    // if delegate does not return a header view that is derived from UITableViewHeaderFooterView
    // however -tableView:didEndDisplayingHeaderView:forSection: is called
    UIView * headerView = [self.tableViewDelegate tableView:tableView viewForHeaderInSection:section];
    [self.ninjaTableView registerHeaderView:headerView forSection:section];
    
    if ([headerView respondsToSelector:@selector(willAppearInSection:)] == YES)
        [headerView performSelector:@selector(willAppearInSection:) withObject:@(section)];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)] == NO){
        return 0;
    }
    
    if ([self.ninjaTableView isSectionHidden:section] == YES) {
        return CGFLOAT_MIN;     // workaround to make section header really invisible, 0 returned here causes a bug - Apple will use "default" section header height instead
    }
    
    return [self.tableViewDelegate tableView:tableView heightForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)] == NO){
        return 0;
    }
    
    if ([self.ninjaTableView isSectionHidden:section] == YES) {
        return CGFLOAT_MIN;     // workaround to make section footer really invisible, 0 returned here causes a bug - Apple will use "default" section footer height instead
    }
    
    return [self.tableViewDelegate tableView:tableView heightForFooterInSection:section];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // headerView is already registered in -tableView:viewForHeaderInSection: method
    //[self.ninjaTableView registerHeaderView:view forSection:section];
    
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)] == YES)
        [self.tableViewDelegate tableView:tableView willDisplayHeaderView:view forSection:section];
    
    // header view is alredy notified about appearing in -tableView:viewForHeaderInSection: method
//    if ([view respondsToSelector:@selector(willAppearInSection:)] == YES)
//        [view performSelector:@selector(willAppearInSection) withObject:@(section)];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    [self.ninjaTableView unregisterHeaderView:view fromSection:section];
    
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didEndDisplayingHeaderView:forSection:)] == YES)
        [self.tableViewDelegate tableView:tableView didEndDisplayingHeaderView:view forSection:section];
    
    if ([view respondsToSelector:@selector(willDisappearFromSection:)] == YES)
        [view performSelector:@selector(willDisappearFromSection:) withObject:@(section)];
}

@end


@implementation CATransaction(Blocks)
+ (void)performWithTransactionBlock:(void (^)())transaction afterTransactionCommitBlock:(void (^)())acommit transactionCompletionBlock:(void (^)())completion
{
    [CATransaction begin];
    if (completion != nil) {
        [CATransaction setCompletionBlock:^{
            completion();
        }];
    }
    
    if (transaction != nil) transaction();
    [CATransaction commit];
    if (acommit != nil) acommit();
}
@end