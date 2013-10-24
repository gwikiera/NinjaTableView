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

#import "NGNinjaTableView.h"


@protocol NGNinjaTableViewHeaderFooterViewAppearing <NSObject>

- (void)willAppearInSection:(NSInteger)section;
- (void)willDisappearFromSection:(NSInteger)section;

@end


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
- (NSInteger)sectionForHeaderView:(UIView *)headerView;

// other
- (CGFloat)emptyContentHeight;

@end
