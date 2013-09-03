//
//  NGButtonCell.m
//  NinjaTableView
//
//  Created by Wojtek Nagrodzki on 17/12/2012.
//  Copyright (c) 2012 Wojtek Nagrodzki. All rights reserved.
//

#import "NGButtonCell.h"

@implementation NGButtonCell {
    UIButton * _buttonA;
    UIButton * _buttonB;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _buttonA = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_buttonA setTitle:@"A" forState:UIControlStateNormal];
        [_buttonA addTarget:self action:@selector(buttonATapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_buttonA];
        _buttonB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_buttonB setTitle:@"B" forState:UIControlStateNormal];
        [_buttonB addTarget:self action:@selector(buttonBTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_buttonB];
    }
    return self;
}

- (void)layoutSubviews
{
    CGRect frame = self.bounds;
    frame.size.width = frame.size.width / 2;
    _buttonA.frame = frame;
    
    frame.origin.x = frame.size.width;
    _buttonB.frame = frame;
}

- (void)buttonATapped:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(buttonCell:fromTableView:atIndexPathDidTapButtonA:)])
        [self.delegate buttonCell:self fromTableView:self.tableView atIndexPathDidTapButtonA:self.indexPath];
}

- (void)buttonBTapped:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(buttonCell:fromTableView:atIndexPathDidTapButtonB:)])
        [self.delegate buttonCell:self fromTableView:self.tableView atIndexPathDidTapButtonB:self.indexPath];
}

@end
