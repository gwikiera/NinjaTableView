//
//  NGNinjaTableViewDelegateSurrogate.m
//  NinjaTableView
//
//  Created by Krzysztof Profic on 04/02/14.
//  Copyright (c) 2014 Wojtek Nagrodzki. All rights reserved.
//

#import "NGNinjaTableViewDelegateSurrogate.h"

#pragma clang push
#pragma clang diagnostic ignored "-Wprotocol"

/**
 *  @warning: Some methods from @see UITableViewDelegate may be for convenience reimplemented in @see NGNinjaTableView+SectionManagement
 */
@implementation NGNinjaTableViewDelegateSurrogate

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.proxiedObject respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)] == YES)
        [self.proxiedObject tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    
    if ([cell respondsToSelector:@selector(willAppearInRowAtIndexPath:)])
        [cell performSelector:@selector(willAppearInRowAtIndexPath:) withObject:indexPath];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([self.proxiedObject respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)] == YES)
        [self.proxiedObject tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    
    if ([cell respondsToSelector:@selector(didDisappearFromRowAtIndexPath:)])
        [cell performSelector:@selector(didDisappearFromRowAtIndexPath:) withObject:indexPath];
}

@end

#pragma clang pop