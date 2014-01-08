//
//  NGTextFieldCellDemoViewController.m
//  NinjaTableView
//
//  Created by Wojtek Nagrodzki on 08/06/2013.
//  Copyright (c) 2013 Wojtek Nagrodzki. All rights reserved.
//

#import "NGTextFieldCellDemoViewController.h"
#import "NGTextFieldTableViewCell.h"


@implementation NGTextFieldCellDemoViewController

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const cellIdentifier = @"TextFieldCell";
    NGTextFieldTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NGTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textField.text = [NSString stringWithFormat:@"Index path: %d %d", indexPath.section, indexPath.row];

    return cell;
}

#pragma mark - NGResponderTableViewCellDelegate

- (void)responderTableViewCellDidResignFirstResponder:(NGResponderTableViewCell *)cell
{
    NSIndexPath * nextCellIndexPath = [NSIndexPath indexPathForRow:cell.indexPath.row+1 inSection:cell.indexPath.section];
    NGResponderTableViewCell * nextCell = (NGResponderTableViewCell *)[cell.tableView cellForRowAtIndexPath:nextCellIndexPath];
    [nextCell becomeFirstResponder];
}

#pragma mark - NGTextFieldTableViewCellDelegate

- (BOOL)textFieldTableViewCell:(NGTextFieldTableViewCell *)textFieldTableViewCell textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)textFieldTableViewCell:(NGTextFieldTableViewCell *)textFieldTableViewCell textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"TextField %@ in cell at index path : %@ did begin editing", textField, textFieldTableViewCell.indexPath);
}

- (void)textFieldTableViewCell:(NGTextFieldTableViewCell *)textFieldTableViewCell textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"TextField %@ in cell at index path : %@ did end editing", textField, textFieldTableViewCell.indexPath);
}

@end
