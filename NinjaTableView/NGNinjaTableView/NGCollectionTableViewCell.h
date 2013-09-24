//
//  NGCollectionTableViewCell.h
//  NinjaTableView
//
//  Created by Wojtek Nagrodzki on 23/09/2013.
//  Copyright (c) 2013 Wojtek Nagrodzki. All rights reserved.
//

#import "NGNinjaTableViewCell.h"

@class NGCollectionTableViewCell;


@protocol NGCollectionTableViewCellDataSource <NSObject>

- (NSInteger)collectionTableViewCell:(NGCollectionTableViewCell *)collectionTableViewCell collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)collectionTableViewCell:(NGCollectionTableViewCell *)collectionTableViewCell collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@protocol NGCollectionTableViewCellDelegate <NSObject>

- (void)collectionTableViewCell:(NGCollectionTableViewCell *)collectionTableViewCell didPrepareCollectionViewLayout:(UICollectionViewFlowLayout *)collectionViewLayout;
- (void)collectionTableViewCell:(NGCollectionTableViewCell *)collectionTableViewCell didPrepareCollectionView:(UICollectionView *)collectionView;

@optional

- (NSArray *)collectionTableViewCell:(NGCollectionTableViewCell *)collectionTableViewCell preselectedItemIndexPathsForCollectionView:(UICollectionView *)collectionView;
- (void)collectionTableViewCell:(NGCollectionTableViewCell *)collectionTableViewCell collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface NGCollectionTableViewCell : NGNinjaTableViewCell {
  @protected
    UICollectionView * _collectionView;
}

@end
