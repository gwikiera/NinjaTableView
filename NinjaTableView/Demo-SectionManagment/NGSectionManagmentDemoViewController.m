//
//  NGSectionManagmentDemoViewController.m
//  NinjaTableView
//
//  Created by Krzysztof Profic on 19/09/2013.
//  Copyright (c) 2013 Krzysztof Profic. All rights reserved.
//

#import "NGSectionManagmentDemoViewController.h"
#import "NGNinjaTableView+SectionManagement.h"


@interface NGSectionManagmentDemoViewController ()

@end

@implementation NGSectionManagmentDemoViewController

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton * btn = [[UIButton alloc] init];
    [btn setTitle:[NSString stringWithFormat:@"Section %d header", section] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(didSelectHeaderView:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = section;
    return btn;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"cell %d in section %d", indexPath.row, indexPath.section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NGNinjaTableView * tv = (NGNinjaTableView *)tableView;
    [tv toggleFoldingOnSection:indexPath.section];
}

#pragma mark - Private Methods

- (void)didSelectHeaderView:(UIButton *)sender
{
    NGNinjaTableView * tv = (NGNinjaTableView *)self.tableView;
    [tv toggleFoldingOnSection:sender.tag];
}

@end
