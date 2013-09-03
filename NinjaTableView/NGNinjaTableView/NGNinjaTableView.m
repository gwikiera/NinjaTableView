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

#import "NGNinjaTableView.h"


@interface NGNinjaTableViewDelegateSurrogate : NSObject <UITableViewDelegate>

@property (weak, nonatomic) id ninjaTableViewDelegate;
@property (weak, nonatomic) NGNinjaTableView * ninjaTableView;

@end


@implementation NGNinjaTableViewDelegateSurrogate

#pragma mark - Overriden

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self.ninjaTableViewDelegate respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.ninjaTableViewDelegate];
        return;
    }
    
    [super forwardInvocation:anInvocation];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector] == YES)
        return YES;
    
    return [self.ninjaTableViewDelegate respondsToSelector:aSelector];
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (self.ninjaTableViewDelegate != nil) {
        signature = [self.ninjaTableViewDelegate methodSignatureForSelector:selector];
    }
    return signature;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.ninjaTableViewDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)] == YES)
        [self.ninjaTableViewDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    
    if ([cell respondsToSelector:@selector(willAppearInRowAtIndexPath:)])
        [cell performSelector:@selector(willAppearInRowAtIndexPath:) withObject:indexPath];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([self.ninjaTableViewDelegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)] == YES)
        [self.ninjaTableViewDelegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    
    if ([cell respondsToSelector:@selector(didDisappearFromRowAtIndexPath:)])
        [cell performSelector:@selector(didDisappearFromRowAtIndexPath:) withObject:indexPath];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.ninjaTableViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)] == YES)
        [self.ninjaTableViewDelegate scrollViewWillBeginDragging:scrollView];
    
    [scrollView endEditing:YES];
}

@end


@interface NGNinjaTableView ()

@property (strong, nonatomic) NSMutableDictionary * cellData;
@property (strong, nonatomic) NGNinjaTableViewDelegateSurrogate * delegateSurrogate;

@end


@implementation NGNinjaTableView

#pragma mark - Instance Methods

- (void)setData:(id)data forIndexPath:(NSIndexPath *)indexPath
{
    if (data == nil)
        [self.cellData removeObjectForKey:indexPath];
    else
        [self.cellData setObject:data forKey:indexPath];
}

- (id)dataForIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellData objectForKey:indexPath];
}

#pragma mark - Overriden

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    self.delegateSurrogate.ninjaTableViewDelegate = delegate;
    [super setDelegate:self.delegateSurrogate];
}

#pragma mark - Private Properties

- (NSMutableDictionary *)cellData
{
    if (_cellData == nil) {
        _cellData = [NSMutableDictionary dictionary];
    }
    return _cellData;
}

- (NGNinjaTableViewDelegateSurrogate *)delegateSurrogate
{
    if (_delegateSurrogate == nil) {
        _delegateSurrogate = [[NGNinjaTableViewDelegateSurrogate alloc] init];
        _delegateSurrogate.ninjaTableView = self;
    }
    return _delegateSurrogate;
}

@end
