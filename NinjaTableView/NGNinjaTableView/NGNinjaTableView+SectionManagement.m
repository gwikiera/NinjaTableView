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
void *allowsUnfoldingOnMultipleSectionsKey = &allowsUnfoldingOnMultipleSectionsKey;

@interface CATransaction(Blocks)
+ (void)performWithBlock:(void(^)())transaction beforeBegin:(void(^)())bbegin afterCommit:(void(^)())acommit completion:(void(^)())completion;
@end

@interface NGNinjaTableView()
@property (nonatomic, readwrite) NSMutableIndexSet * foldedSectionsIndexSet;
@property (nonatomic, readwrite) NSMutableIndexSet * hiddenSectionsIndexSet;
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
    
    [CATransaction performWithBlock:^{
        [self reloadSections:indices withRowAnimation: animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone];
    } beforeBegin:^{
        [self.foldedSectionsIndexSet addIndexes:indices];
    } afterCommit:^{
        if ([self.delegate respondsToSelector:@selector(tableView:didStartFoldingSections:animated:)] == YES){
            [(id)self.delegate tableView:self didStartFoldingSections:indices animated:animated];
        }
    } completion:^{
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
    [CATransaction performWithBlock:^{
        [self reloadSections:sectionsToReload withRowAnimation: animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone];
    } beforeBegin:nil afterCommit:^{
        if ([self.delegate respondsToSelector:@selector(tableView:didStartUnfoldingSections:animated:)] == YES){
            [(id)self.delegate tableView:self didStartUnfoldingSections:sectionsToUnfold animated:animated];
        }
    } completion:^{
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

    
    [CATransaction performWithBlock:^{
        [self reloadSections:indices withRowAnimation: animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone];
    } beforeBegin:^{
        [self.hiddenSectionsIndexSet addIndexes:indices];
    } afterCommit:^{
        if ([self.delegate respondsToSelector:@selector(tableView:didStartHidingSections:animated:)] == YES) {
            [(id)self.delegate tableView:self didStartHidingSections:indices animated:animated];
        }
    } completion:^{
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
    
    [CATransaction performWithBlock:^{
        [self reloadSections:indices withRowAnimation: animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone];
    } beforeBegin:^{
        [self.hiddenSectionsIndexSet removeIndexes:indices];
    } afterCommit:^{
        if ([self.delegate respondsToSelector:@selector(tableView:didStartShowingSections:animated:)] == YES) {
            [(id)self.delegate tableView:self didStartShowingSections:indices animated:animated];
        }
    } completion:^{
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

#pragma mark - Interface Properties

- (NSMutableIndexSet *)foldedSectionsIndexSet
{
    NSMutableIndexSet * indexSet = objc_getAssociatedObject(self, foldedSectionsIndexSetKey);
    if (indexSet == nil){
        indexSet = [NSMutableIndexSet indexSet];
        objc_setAssociatedObject(self, foldedSectionsIndexSetKey, indexSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return indexSet;
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
    return indexSet;
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

#pragma mark - Interface Methods

- (BOOL)isSectionFolded:(NSInteger)section
{
    return [self.foldedSectionsIndexSet containsIndex:section];
}

- (BOOL)isSectionHidden:(NSInteger)section
{
    return [self.hiddenSectionsIndexSet containsIndex:section];
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
    
    return [self.tableViewDelegate tableView:tableView viewForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)] == NO){
        return 0;
    }
    
    if ([self.ninjaTableView isSectionHidden:section] == YES) {
        return CGFLOAT_MIN;
    }
    
    return [self.tableViewDelegate tableView:tableView heightForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)] == NO){
        return 0;
    }
    
    if ([self.ninjaTableView isSectionHidden:section] == YES) {
        return CGFLOAT_MIN;
    }
    
    return [self.tableViewDelegate tableView:tableView heightForFooterInSection:section];
}

@end


@implementation CATransaction(Blocks)
+ (void)performWithBlock:(void (^)())transaction beforeBegin:(void (^)())bbegin afterCommit:(void (^)())acommit completion:(void (^)())completion
{
    if (bbegin != nil) bbegin();
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