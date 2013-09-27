//
//  NGCollectionTableViewCell.m
//  NinjaTableView
//
//  Created by Wojtek Nagrodzki on 23/09/2013.
//  Copyright (c) 2013 Wojtek Nagrodzki. All rights reserved.
//

#import "NGCollectionTableViewCell.h"


static NSString * const kContentOffsetKey = @"contentOffset";
static NSString * const kIndexPathsForSelectedItemsKey = @"indexPathsForSelectedItems";


@interface NGCollectionTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView * collectionView;

@end


@implementation NGCollectionTableViewCell

#pragma mark - Overridden

- (void)didMoveToSuperview
{
    if (_collectionView.superview != nil)
        return;
    
    [self.contentView addSubview:self.collectionView];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary * views = @{@"collectionView": self.collectionView};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:0 metrics:nil views:views]];
    
    /** Warning:
     *  Selecting items before collection view calls datasource, is fragile. Client must not select index paths which are out of bounds.
     */
    
    if ([self.delegate respondsToSelector:@selector(collectionTableViewCell:preselectedItemIndexPathsForCollectionView:)] == NO)
        return;
    
    NSArray * indexPaths = [self.delegate collectionTableViewCell:self preselectedItemIndexPathsForCollectionView:self.collectionView];
    for (NSIndexPath * indexPath in indexPaths) {
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

- (void)prepareForReuse
{
    for (NSIndexPath * indexPath in self.collectionView.indexPathsForSelectedItems) {
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
}

- (id)internalStateData
{
    NSValue * contentOffset = [NSValue valueWithCGPoint:self.collectionView.contentOffset];
    NSArray * indexPathsForSelectedItems = [self.collectionView indexPathsForSelectedItems];
    return @{kContentOffsetKey: contentOffset, kIndexPathsForSelectedItemsKey: indexPathsForSelectedItems};
}

- (void)setInternalStateData:(id)data
{
    NSDictionary * dataDictionary = data;
    NSValue * contentOffset = dataDictionary[kContentOffsetKey];
    NSArray * indexPathsForSelectedItems = dataDictionary[kIndexPathsForSelectedItemsKey];
    
    self.collectionView.contentOffset = contentOffset.CGPointValue;
    for (NSIndexPath * indexPath in indexPathsForSelectedItems) {
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

#pragma mark - Private Properties

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [self.delegate collectionTableViewCell:self didPrepareCollectionViewLayout:layout];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [self.delegate collectionTableViewCell:self didPrepareCollectionView:_collectionView];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.delegate collectionTableViewCell:self collectionView:collectionView numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate collectionTableViewCell:self collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(collectionTableViewCell:collectionView:didSelectItemAtIndexPath:)] == YES)
        [self.delegate collectionTableViewCell:self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

#pragma mark - Notifications

@end
