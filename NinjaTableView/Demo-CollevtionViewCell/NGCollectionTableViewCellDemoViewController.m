//
//  NGCollectionTableViewCellDemoViewController.m
//  NinjaTableView
//
//  Created by Wojtek Nagrodzki on 23/09/2013.
//  Copyright (c) 2013 Wojtek Nagrodzki. All rights reserved.
//

#import "NGCollectionTableViewCellDemoViewController.h"
#import "NGCollectionTableViewCell.h"


static NSString * const kCellIdentifier = @"cell";


@interface NGCollectionTableViewCellDemoViewController ()

@end

@implementation NGCollectionTableViewCellDemoViewController


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 32;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const kCellIdentifier = @"cell";
    NGCollectionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[NGCollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    return cell;
}

#pragma mark - NGCollectionTableViewCellDataSource

- (NSInteger)collectionTableViewCell:(NGCollectionTableViewCell *)collectionTableViewCell collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 16;
}

- (UICollectionViewCell *)collectionTableViewCell:(NGCollectionTableViewCell *)collectionTableViewCell collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    UIView * backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor greenColor];
    cell.backgroundView = backgroundView;
    
    UIView * selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = [UIColor redColor];
    cell.selectedBackgroundView = selectedBackgroundView;
    
    return cell;
}

#pragma mark - NGCollectionTableViewCellDelegate

- (void)collectionTableViewCell:(NGCollectionTableViewCell *)collectionTableViewCell didPrepareCollectionViewLayout:(UICollectionViewFlowLayout *)collectionViewLayout
{
    collectionViewLayout.itemSize = CGSizeMake(30, 30);
}

- (void)collectionTableViewCell:(NGCollectionTableViewCell *)collectionTableViewCell didPrepareCollectionView:(UICollectionView *)collectionView
{
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
}

@end
