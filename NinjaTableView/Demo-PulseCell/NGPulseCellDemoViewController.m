//
//  NGPulseCellDemoViewController.m
//  NinjaTableView
//
//  Created by Wojtek Nagrodzki on 06/01/2013.
//  Copyright (c) 2013 Wojtek Nagrodzki. All rights reserved.
//

#import "NGPulseCellDemoViewController.h"
#import "NGPulseTableViewCell.h"


@implementation NGPulseCellDemoViewController

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const cellIdentifier = @"PulseCell";
    NGPulseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NGPulseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

#pragma mark - NGPulseTableViewCellDelegate

- (NSInteger)pulseTableViewCellNumberOfRows:(NGPulseTableViewCell *)pulseCell
{
    return 20;
}

- (UITableViewCell *)pulseTableViewCell:(NGPulseTableViewCell *)pulseCell pulseTableView:(UITableView *)pulseTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const cellIdentifier = @"Cell";
    UITableViewCell * cell = [pulseTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d %d", pulseCell.indexPath.row, indexPath.row];
    return cell;
}

@end
