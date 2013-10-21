//
//  NGButtonCell.h
//  NinjaTableView
//
//  Created by Wojtek Nagrodzki on 17/12/2012.
//  Copyright (c) 2012 Wojtek Nagrodzki. All rights reserved.
//

#import "NGNinjaTableViewCellSubclass.h"

@class NGButtonCell;


@protocol NGButtonCellDelegate <NSObject>

@optional;
- (void)buttonCell:(NGButtonCell *)buttonCell fromTableView:(NGNinjaTableView *)tableView atIndexPathDidTapButtonA:(NSIndexPath *)indexPath;
- (void)buttonCell:(NGButtonCell *)buttonCell fromTableView:(NGNinjaTableView *)tableView atIndexPathDidTapButtonB:(NSIndexPath *)indexPath;

@end


@interface NGButtonCell : NGNinjaTableViewCell

@end
