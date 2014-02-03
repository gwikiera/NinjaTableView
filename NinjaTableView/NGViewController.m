//
//  NGViewController.m
//  NinjaTableView
//
//  Created by Wojtek Nagrodzki on 17/12/2012.
//  Copyright (c) 2012 Wojtek Nagrodzki. All rights reserved.
//

#import "NGViewController.h"
#import "NGButtonCellDemoViewController.h"
#import "NGCollectionTableViewCellDemoViewController.h"
#import "NGSectionManagmentDemoViewController.h"
#import "NGTextFieldCellDemoViewController.h"
#import "NGTextViewCellDemoViewController.h"


static const NSString * demoViewControllerTitleKey = @"demoViewControllerTitleKey";
static const NSString * demoViewControllerClassKey = @"demoViewControllerClassKey";


@interface NGViewController ()

@property (copy, nonatomic) NSArray * demosViewControllers;

@end


@implementation NGViewController

#pragma mark - Overriden

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Ninja Table View Demos";
}

#pragma mark - Private Properties

- (NSArray *)demosViewControllers
{
    if (_demosViewControllers == nil) {
        _demosViewControllers = @[
                                  @{demoViewControllerTitleKey : @"Button Cell Demo",  demoViewControllerClassKey : [NGButtonCellDemoViewController class]},
                                  @{demoViewControllerTitleKey : @"Collection Cell Demo", demoViewControllerClassKey : [NGCollectionTableViewCellDemoViewController class]},
                                  @{demoViewControllerTitleKey : @"Section Managment Cell Demo", demoViewControllerClassKey : [NGSectionManagmentDemoViewController class]},
                                  @{demoViewControllerTitleKey : @"TextField Cell Demo", demoViewControllerClassKey : [NGTextFieldCellDemoViewController class]},
                                  @{demoViewControllerTitleKey : @"TextView Cell Demo", demoViewControllerClassKey : [NGTextViewCellDemoViewController class]},
                                  ];
    }
    return _demosViewControllers;
}

#pragma mark - Private Methods

- (NSString *)titleOfDemoViewControllerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.demosViewControllers[indexPath.row][demoViewControllerTitleKey];
}

- (UIViewController *)demoViewControllerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class demoViewControllerClass = self.demosViewControllers[indexPath.row][demoViewControllerClassKey];
    UIViewController * viewController = [[demoViewControllerClass alloc] initWithNibName:nil bundle:nil];
    viewController.title = [self titleOfDemoViewControllerForRowAtIndexPath:indexPath];
    return viewController;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.demosViewControllers.count;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString * cellIdentifier = @"CellIndentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self titleOfDemoViewControllerForRowAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController * viewController = [self demoViewControllerForRowAtIndexPath:indexPath];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
