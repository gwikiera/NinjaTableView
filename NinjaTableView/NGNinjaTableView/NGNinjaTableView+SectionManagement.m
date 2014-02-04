/*
 * Copyright (c) 2013 Krzysztof Profic
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "NGNinjaTableView+SectionManagement.h"
#import "NGNinjaTableViewSubclass.h"
#import "NGNinjaTableViewDataSourceSurrogate.h"
#import "NGNinjaTableViewDelegateSurrogate.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

void *foldedSectionsMutableIndexSetKey = &foldedSectionsMutableIndexSetKey;
void *hiddenSectionsMutableIndexSetKey = &hiddenSectionsMutableIndexSetKey;
void *sectionsForHeadersKey = &sectionsForHeadersKey;
void *allowsUnfoldingOnMultipleSectionsKey = &allowsUnfoldingOnMultipleSectionsKey;

@interface CATransaction(Blocks)
+ (void)performWithTransactionBlock:(void (^)())transaction afterTransactionCommitBlock:(void (^)())afterCommit transactionCompletionBlock:(void (^)())completion;
@end

@interface NGNinjaTableView()
@property (nonatomic, readwrite) NSMutableIndexSet * foldedSectionsMutableIndexSet;
@property (nonatomic, readwrite) NSMutableIndexSet * hiddenSectionsMutableIndexSet;
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
        [self.foldedSectionsMutableIndexSet addIndexes:indices];
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
        NSIndexSet * oldFoldedSectionsIndexSet = self.foldedSectionsMutableIndexSet;
        NSMutableIndexSet * toReload = [[self allSectionsIndexSet] mutableCopy];
        [toReload removeIndexes:oldFoldedSectionsIndexSet]; // reload also sections that were folded before (closing needs to be performed)
        [toReload addIndexes:sectionsToUnfold];             // reload the section we're unfolding
        sectionsToReload = toReload;
        
        // setup new unfolded section
        self.foldedSectionsMutableIndexSet = [[self allSectionsIndexSet] mutableCopy];
        [self.foldedSectionsMutableIndexSet removeIndexes:sectionsToUnfold];
    }
    else {
        [self.foldedSectionsMutableIndexSet removeIndexes:sectionsToUnfold];
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
        [self.hiddenSectionsMutableIndexSet addIndexes:indices];
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
        [self.hiddenSectionsMutableIndexSet removeIndexes:indices];
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
    return [self.foldedSectionsMutableIndexSet containsIndex:section];
}

- (BOOL)isSectionHidden:(NSInteger)section
{
    return [self.hiddenSectionsMutableIndexSet containsIndex:section];
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

- (NSIndexSet *)foldedSectionsIndexSet
{
    return [self.foldedSectionsMutableIndexSet copy];
}

- (NSIndexSet *)hiddenSectionsIndexSet
{
    return [self.hiddenSectionsMutableIndexSet copy];
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

- (NSMutableIndexSet *)foldedSectionsMutableIndexSet
{
    NSMutableIndexSet * indexSet = objc_getAssociatedObject(self, foldedSectionsMutableIndexSetKey);
    if (indexSet == nil){
        indexSet = [NSMutableIndexSet indexSet];
        objc_setAssociatedObject(self, foldedSectionsMutableIndexSetKey, indexSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return indexSet;
}

- (void)setFoldedSectionsMutableIndexSet:(NSMutableIndexSet *)foldedSectionsMutableIndexSet
{
    objc_setAssociatedObject(self, foldedSectionsMutableIndexSetKey, foldedSectionsMutableIndexSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableIndexSet *)hiddenSectionsMutableIndexSet
{
    NSMutableIndexSet * indexSet = objc_getAssociatedObject(self, hiddenSectionsMutableIndexSetKey);
    if (indexSet == nil){
        indexSet = [NSMutableIndexSet indexSet];
        objc_setAssociatedObject(self, hiddenSectionsMutableIndexSetKey, indexSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return indexSet;
}

#pragma mark - Private Methods

- (NSIndexSet *)allSectionsIndexSet
{
    NSInteger sections = [self.dataSourceSurrogate.proxiedObject numberOfSectionsInTableView:self];
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


@implementation NGNinjaTableViewDataSourceSurrogate(SectionManagment)

#pragma mark - Overriden UITableViewDataSource
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.ninjaTableView isSectionFolded:section] == YES && [self.ninjaTableView isSectionHidden:section] == NO) {
        if ([self.proxiedObject respondsToSelector:@selector(tableView:numberOfRowsInSectionWhenFolded:)] == YES) {
            return [(id)self.proxiedObject tableView:self.ninjaTableView numberOfRowsInSectionWhenFolded:section];
        }
    }
    
    if ([self.ninjaTableView isSectionContentVisible:section] == NO) {
        return 0;
    }
    
    return [self.proxiedObject tableView:tableView numberOfRowsInSection:section];
}

#pragma clang pop

@end

@implementation NGNinjaTableViewDelegateSurrogate(SectionManagment)

#pragma mark - Overriden UITableViewDelegate
//
// We can't require somebody to implement the following methods
// We even can not say that that the particular method is not implemented (respondsToSelector == NO)
// so the methods below will be just forwarded to the real delegate to return defaults because
// tableView will ommit what we've implemented here (respondsToSelector == NO) == no implementation.
// Because of that we should return default values, however it's nontrivial and sometimes imposible to predict them
// that's why I simply return 0, nil aso. If somebody want's to use headers or footers,
// he will most probably override those methods anyway so that's not too bad.
//
- (UIView *)tableView:(NGNinjaTableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.proxiedObject respondsToSelector:@selector(tableView:viewForHeaderInSection:)] == NO) {
        return nil;
    }
    
    if ([self.ninjaTableView isSectionHidden:section] == YES) {
        return nil;
    }
    
    // The reason headeView is registered here is that UITableView does not call -tableView:willDisplayHeaderView:forSection:
    // if delegate does not return a header view that is derived from UITableViewHeaderFooterView
    // however -tableView:didEndDisplayingHeaderView:forSection: is called
    UIView * headerView = [self.proxiedObject tableView:tableView viewForHeaderInSection:section];
    [self.ninjaTableView registerHeaderView:headerView forSection:section];
    
    if ([headerView respondsToSelector:@selector(willAppearInTableView:atSection:)] == YES)
        [ (id <NGNinjaTableViewHeaderFooterViewAppearing>)headerView willAppearInTableView:tableView atSection:section];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.proxiedObject respondsToSelector:@selector(tableView:heightForHeaderInSection:)] == NO){
        return 0;
    }
    
    if ([self.ninjaTableView isSectionHidden:section] == YES) {
        return CGFLOAT_MIN;     // workaround to make section header really invisible, 0 returned here causes a bug - Apple will use "default" section header height instead
    }
    
    return [self.proxiedObject tableView:tableView heightForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self.proxiedObject respondsToSelector:@selector(tableView:heightForFooterInSection:)] == NO){
        return 0;
    }
    
    if ([self.ninjaTableView isSectionHidden:section] == YES) {
        return CGFLOAT_MIN;     // workaround to make section footer really invisible, 0 returned here causes a bug - Apple will use "default" section footer height instead
    }
    
    return [self.proxiedObject tableView:tableView heightForFooterInSection:section];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // headerView is already registered in -tableView:viewForHeaderInSection: method
    //[self.ninjaTableView registerHeaderView:view forSection:section];
    
    if ([self.proxiedObject respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)] == YES)
        [self.proxiedObject tableView:tableView willDisplayHeaderView:view forSection:section];
    
    // header view is alredy notified about appearing in -tableView:viewForHeaderInSection: method
    //    if ([headerView respondsToSelector:@selector(willAppearInTableView:atSection:)] == YES)
    //        [ (id <NGNinjaTableViewHeaderFooterViewAppearing>)viewiew willAppearInTableView:tableView atSection:section];

}

- (void)tableView:(NGNinjaTableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    [self.ninjaTableView unregisterHeaderView:view fromSection:section];
    
    if ([self.proxiedObject respondsToSelector:@selector(tableView:didEndDisplayingHeaderView:forSection:)] == YES)
        [self.proxiedObject tableView:tableView didEndDisplayingHeaderView:view forSection:section];
    
    if ([view respondsToSelector:@selector(willDisappearFromTableView:atSection:)] == YES)
        [ (id <NGNinjaTableViewHeaderFooterViewAppearing>)view willDisappearFromTableView:tableView atSection:section];
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