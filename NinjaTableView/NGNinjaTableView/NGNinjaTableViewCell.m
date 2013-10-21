/*
 * Copyright (c) 2012 Wojciech Nagrodzki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "NGNinjaTableViewCell.h"


@implementation NGNinjaTableViewCell

#pragma mark - Instance Methods

- (id)internalStateData
{
    return nil;
}

- (void)setInternalStateData:(id)data
{
    // does nothing
}

#pragma mark - Private Properties

- (id)delegate
{
    UIView * tableView = [self superview];
    while (tableView != nil && [tableView isKindOfClass:UITableView.class] == NO) {
        tableView = [tableView superview];
    }
    
    NSParameterAssert([tableView isKindOfClass:[NGNinjaTableView class]] == YES);
    return [tableView valueForKey:@"delegate"];
}

- (NSIndexPath *)indexPath
{
    return [self.tableView indexPathForCell:self];
}

- (NGNinjaTableView *)tableView
{
    if ([self.superview isKindOfClass:[NGNinjaTableView class]] == YES)
        return (NGNinjaTableView *)self.superview;
    
    return nil;
}

#pragma mark - NGNinjaTableViewCellAppearing

- (void)willAppearInRowAtIndexPath:(NSIndexPath *)indexPath
{
    id internalStateData = [self.tableView dataForIndexPath:indexPath];
    [self setInternalStateData:internalStateData];
}

- (void)didDisappearFromRowAtIndexPath:(NSIndexPath*)indexPath
{
    id internalStateData = [self internalStateData];
    [self.tableView setData:internalStateData forIndexPath:indexPath];
}

@end
