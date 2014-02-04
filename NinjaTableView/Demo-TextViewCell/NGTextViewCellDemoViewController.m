//
//  NGTextViewCellDemoViewController.m
//  NinjaTableView
//
//  Created by Grzegorz Wikiera on 08.01.2014.
//  Copyright (c) 2014 Wojtek Nagrodzki. All rights reserved.
//

#import "NGTextViewCellDemoViewController.h"
#import "NGTextViewTableViewCell.h"


@implementation NGTextViewCellDemoViewController

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const cellIdentifier = @"TextViewCell";
    NGTextViewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NGTextViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textView.layer.borderWidth = 1.0f;
    }
    cell.textView.text = [NSString stringWithFormat:@"Index path: %d %d", indexPath.section, indexPath.row];
    
    return cell;
}

#pragma mark - NGTextViewTableViewCellDelegate

- (void)textViewTableViewCell:(NGTextViewTableViewCell *)textViewTableViewCell textViewDidBeginEditing:(UITextView *)textView;
{
    NSLog(@"TextView %@ in cell at index path : %@ did begin editing", textView, textViewTableViewCell.indexPath);
}

- (void)textViewTableViewCell:(NGTextViewTableViewCell *)textViewTableViewCell textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"TextView %@ in cell at index path : %@ did end editing", textView, textViewTableViewCell.indexPath);
}

@end
