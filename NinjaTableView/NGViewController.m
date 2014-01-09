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

@interface NGViewController ()

@end

@implementation NGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonCellDemoTapped:(id)sender
{
    NGButtonCellDemoViewController * controller = [[NGButtonCellDemoViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)collectionCellDemoTapped:(id)sender
{
    NGCollectionTableViewCellDemoViewController * controller = [[NGCollectionTableViewCellDemoViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)sectionManagmentDemoTapped:(id)sender
{
    NGSectionManagmentDemoViewController * controller = [[NGSectionManagmentDemoViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)textFieldCellDemoTapped:(id)sender
{
    NGTextFieldCellDemoViewController * controller = [[NGTextFieldCellDemoViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)textViewCellDemoTapped:(id)sender
{
    NGTextViewCellDemoViewController * controller = [[NGTextViewCellDemoViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
