//
//  NGButtonCellDemoViewController.m
//  NinjaTableView
//
//  Created by Wojtek Nagrodzki on 17/12/2012.
//  Copyright (c) 2012 Wojtek Nagrodzki. All rights reserved.
//

#import "NGButtonCellDemoViewController.h"
#import "NGButtonCell.h"


@implementation NGButtonCellDemoViewController

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 24;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const identifier = @"cell";
    NGButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NGButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor grayColor];
    }
    return cell;
}

#pragma mark - NGButtonCellDelegate

- (void)buttonCell:(NGButtonCell *)buttonCell fromTableView:(NGNinjaTableView *)tableView atIndexPathDidTapButtonA:(NSIndexPath *)indexPath
{
    NSLog(@"Button A tapped at index path : %@", indexPath);
}

- (void)buttonCell:(NGButtonCell *)buttonCell fromTableView:(NGNinjaTableView *)tableView atIndexPathDidTapButtonB:(NSIndexPath *)indexPath
{
    NSLog(@"Button B tapped at index path : %@", indexPath);
}

@end
