/*
 * Copyright (c) 2014 Krzysztof Profic
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

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.proxiedObject respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)] == YES)
        [self.proxiedObject tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    
    if ([cell respondsToSelector:@selector(didDisappearFromRowAtIndexPath:)])
        [cell performSelector:@selector(didDisappearFromRowAtIndexPath:) withObject:indexPath];
}

@end

#pragma clang pop