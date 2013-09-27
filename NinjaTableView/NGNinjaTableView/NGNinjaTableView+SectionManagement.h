//
//  NGNinjaTableView+SectionManagement.h
//  NinjaTableView
//
//  Created by Krzysztof Profic on 19/09/2013.
//  Copyright (c) 2013 Krzysztof Profic. All rights reserved.
//

#import "NGNinjaTableView.h"

@protocol NGSectionManagementDelegate <UITableViewDelegate>
@optional
- (NSIndexSet *)tableView:(UITableView *)tableView willStartFoldingSections:(NSIndexSet *)sections animated:(BOOL)animated;
- (void)tableView:(UITableView *)tableView didStartFoldingSections:(NSIndexSet *)sections animated:(BOOL)animated;
- (void)tableView:(UITableView *)tableView didFinishFoldingSections:(NSIndexSet *)sections animated:(BOOL)animated;

- (NSIndexSet *)tableView:(UITableView *)tableView willStartUnfoldingSections:(NSIndexSet *)sections animated:(BOOL)animated;
- (void)tableView:(UITableView *)tableView didStartUnfoldingSections:(NSIndexSet *)sections animated:(BOOL)animated;
- (void)tableView:(UITableView *)tableView didFinishUnfoldingSections:(NSIndexSet *)sections animated:(BOOL)animated;

// TODO hiding / showing delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSectionWhenFolded:(NSInteger)section;  // 0 by default
@end


@interface NGNinjaTableView (SectionManagement)

@property (nonatomic, unsafe_unretained) BOOL allowsUnfoldingOnMultipleSections; // YES by default, setter may be called when the tableView view is already loaded, if set to NO all sections become closed
@property (nonatomic, readonly) NSIndexSet * foldedSectionsIndexSet;
@property (nonatomic, readonly) NSIndexSet * hiddenSectionsIndexSet;

// folding / unfolding
- (void)foldSections:(NSIndexSet *)sections animated:(BOOL)animated;
- (void)foldSection:(NSInteger)section animated:(BOOL)animated;

- (void)unfoldSections:(NSIndexSet *)sections animated:(BOOL)animated;
- (void)unfoldSection:(NSInteger)section animated:(BOOL)animated;

- (void)toggleFoldingOnSection:(NSInteger)section;

// hiding / showing
- (void)hideSections:(NSIndexSet *)indices animated:(BOOL)animated;
- (void)hideSection:(NSInteger)section animated:(BOOL)animated;

- (void)showSections:(NSIndexSet *)indices animated:(BOOL)animated;
- (void)showSection:(NSInteger)section animated:(BOOL)animated;

- (void)toggleVisibilityOnSection:(NSInteger)section;

// examining sections
- (BOOL)isSectionFolded:(NSInteger)section;
- (BOOL)isSectionHidden:(NSInteger)section;

@end
