//
//  NGTextFieldCellDemoViewController.m
//  NinjaTableView
//
//  Created by Wojtek Nagrodzki on 08/06/2013.
//  Copyright (c) 2013 Wojtek Nagrodzki. All rights reserved.
//

#import "NGTextFieldCellDemoViewController.h"
#import "NGTextFieldTableViewCell.h"

@interface NGTextFieldCellDemoViewController ()

@end

@implementation NGTextFieldCellDemoViewController {
    __weak IBOutlet NGNinjaTableView *_tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableViewController * controller = [[UITableViewController alloc] init];
    controller.tableView = _tableView;
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
}

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
    return cell;
}

#pragma mark - NGResponderTableViewCellDelegate

- (void)responderTableViewCellDidResignFirstResponder:(NGResponderTableViewCell *)cell
{
    NSIndexPath * nextCellIndexPath = [NSIndexPath indexPathForRow:cell.indexPath.row+1 inSection:cell.indexPath.section];
    NGResponderTableViewCell * nextCell = (NGResponderTableViewCell *)[cell.tableView cellForRowAtIndexPath:nextCellIndexPath];
    [nextCell becomeFirstResponder];
}

@end
