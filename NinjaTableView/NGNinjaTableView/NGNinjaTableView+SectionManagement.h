//
//  NGNinjaTableView+SectionManagement.h
//  NinjaTableView
//
//  Created by Krzysztof Profic on 19/09/2013.
//  Copyright (c) 2013 Krzysztof Profic. All rights reserved.
//

#import "NGNinjaTableView.h"

@interface NGNinjaTableView (SectionManagement)

@property (nonatomic, readonly) NSIndexSet * foldedSectionsIndexSet;
@property (nonatomic, readonly) NSIndexSet * hiddenSectionsIndexSet;

// folding / unfolding
- (void)foldSections:(NSIndexSet *)indices animated:(BOOL)animated;
- (void)foldSection:(NSInteger)section animated:(BOOL)animated;

- (void)unfoldSections:(NSIndexSet *)indices animated:(BOOL)animated;
- (void)unfoldSection:(NSInteger)section animated:(BOOL)animated;

- (void)toggleFoldingOnSection:(NSInteger)section;

// hiding / showing
- (void)hideSections:(NSIndexSet *)indices animated:(BOOL)animated;
- (void)hideSection:(NSInteger)section animated:(BOOL)animated;

- (void)showSections:(NSIndexSet *)indices animated:(BOOL)animated;
- (void)showSection:(NSInteger)section animated:(BOOL)animated;

- (void)toggleVisibilityOnSection:(NSInteger)section;

@end
