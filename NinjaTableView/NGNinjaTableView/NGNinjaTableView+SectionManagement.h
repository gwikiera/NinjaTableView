//
//  NGNinjaTableView+SectionManagement.h
//  NinjaTableView
//
//  Created by Krzysztof Profic on 19/09/2013.
//  Copyright (c) 2013 Krzysztof Profic. All rights reserved.
//

#import "NGNinjaTableView.h"

@protocol NGSectionManagementDelegate <NSObject>    // object that may implement this protocol is UITableViews' "delegate"
@optional
// folding / unfolding delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSectionWhenFolded:(NSInteger)section;  // 0 by default

- (NSIndexSet *)tableView:(UITableView *)tableView willStartFoldingSections:(NSIndexSet *)sections animated:(BOOL)animated;
- (void)tableView:(UITableView *)tableView didStartFoldingSections:(NSIndexSet *)sections animated:(BOOL)animated;
- (void)tableView:(UITableView *)tableView didFinishFoldingSections:(NSIndexSet *)sections animated:(BOOL)animated;
- (NSIndexSet *)tableView:(UITableView *)tableView willStartUnfoldingSections:(NSIndexSet *)sections animated:(BOOL)animated;
- (void)tableView:(UITableView *)tableView didStartUnfoldingSections:(NSIndexSet *)sections animated:(BOOL)animated;
- (void)tableView:(UITableView *)tableView didFinishUnfoldingSections:(NSIndexSet *)sections animated:(BOOL)animated;

// hiding / showing delegate methods
- (NSIndexSet *)tableView:(UITableView *)tableView willStartHidingSections:(NSIndexSet *)sections animated:(BOOL)animated;
- (void)tableView:(UITableView *)tableView didStartHidingSections:(NSIndexSet *)sections animated:(BOOL)animated;
- (void)tableView:(UITableView *)tableView didFinishHidingSections:(NSIndexSet *)sections animated:(BOOL)animated;
- (NSIndexSet *)tableView:(UITableView *)tableView willStartShowingSections:(NSIndexSet *)sections animated:(BOOL)animated;
- (void)tableView:(UITableView *)tableView didStartShowingSections:(NSIndexSet *)sections animated:(BOOL)animated;
- (void)tableView:(UITableView *)tableView didFinishShowingSections:(NSIndexSet *)sections animated:(BOOL)animated;
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
- (void)hideSections:(NSIndexSet *)sections animated:(BOOL)animated;
- (void)hideSection:(NSInteger)section animated:(BOOL)animated;
- (void)showSections:(NSIndexSet *)sections animated:(BOOL)animated;
- (void)showSection:(NSInteger)section animated:(BOOL)animated;
- (void)toggleVisibilityOnSection:(NSInteger)section;

// examining sections
- (BOOL)isSectionFolded:(NSInteger)section;
- (BOOL)isSectionHidden:(NSInteger)section;

// other
- (CGFloat)emptyContentHeight;

@end
