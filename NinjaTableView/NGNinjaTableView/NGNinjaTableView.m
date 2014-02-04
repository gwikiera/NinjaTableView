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
#import "NGNinjaTableViewDataSourceSurrogate.h"
#import "NGNinjaTableViewDelegateSurrogate.h"

@interface NGNinjaTableView ()

@property (strong, nonatomic) NSMutableDictionary * cellData;
@property (strong, nonatomic) NGNinjaTableViewDataSourceSurrogate * dataSourceSurrogate;
@property (strong, nonatomic) NGNinjaTableViewDelegateSurrogate * delegateSurrogate;

@end


@implementation NGNinjaTableView

#pragma mark - Overriden

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    _delegateSurrogate = [[NGNinjaTableViewDelegateSurrogate alloc] initWithProxiedObject:delegate andTableView:self];
    [super setDelegate:_delegateSurrogate];
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    _dataSourceSurrogate = [[NGNinjaTableViewDataSourceSurrogate alloc] initWithProxiedObject:dataSource andTableView:self];
    [super setDataSource:_dataSourceSurrogate];
}

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

#pragma mark - Private Properties

- (NSMutableDictionary *)cellData
{
    if (_cellData == nil) {
        _cellData = [NSMutableDictionary dictionary];
    }
    return _cellData;
}

@end
