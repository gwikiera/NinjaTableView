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

- (void)foldSections:(NSIndexSet *)indices animated:(BOOL)animated;
- (void)foldSection:(NSInteger)section animated:(BOOL)animated;

- (void)unfoldSections:(NSIndexSet *)indices animated:(BOOL)animated;
- (void)unfoldSection:(NSInteger)section animated:(BOOL)animated;

- (void)toggleFoldingOnSection:(NSInteger)section;

// hide
@end
