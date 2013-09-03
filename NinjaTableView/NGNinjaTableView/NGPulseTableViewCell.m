//
//  NGPulseTableViewCell.m
//  TableViewMadness
//
//  Created by Wojciech Nagrodzki on 03/10/2012.
//  Copyright (c) 2012 Trifork. All rights reserved.
//

#import "NGPulseTableViewCell.h"
#import "NGNinjaTableView.h"


static NSString * const kContentOffsetKey = @"contentOffset";
static NSString * const kIndexPathsForSelectedRowsKey = @"indexPathsForSelectedRows";


@interface NGPulseTableViewCell () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView * pulseTableView;

// begin support for iOS < iOS 6.0
@property (strong, nonatomic) NSIndexPath * previousIndexPath;
// end support for iOS < iOS 6.0

@end


@implementation NGPulseTableViewCell

#pragma mark - Overriden

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.pulseTableView.frame = self.contentView.bounds;
}

#pragma mark - Overriden (NGNinjaTableViewCell)

- (id)internalStateData
{
    // save content offset
    NSValue * contentOffset = [NSValue valueWithCGPoint:self.pulseTableView.contentOffset];
    
    // save selected index paths
    NSArray * selectedRows = self.pulseTableView.indexPathsForSelectedRows;
    if (selectedRows == nil)
        selectedRows = [NSArray array];
    
    return  @{kContentOffsetKey : contentOffset, kIndexPathsForSelectedRowsKey : selectedRows};
}

- (void)setInternalStateData:(id)data
{
    [_pulseTableView reloadData];
    
    NSDictionary * cellData = data;
    
    // load content offset
    NSValue * contentOffset = [cellData objectForKey:kContentOffsetKey];
    self.pulseTableView.contentOffset = [contentOffset CGPointValue];
    
    // load seleced index paths
    NSArray * selectedRows = [cellData objectForKey:kIndexPathsForSelectedRowsKey];
    for (NSIndexPath * index in selectedRows) {
        [self.pulseTableView selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - Private Properties

- (UITableView *)pulseTableView
{
    if (_pulseTableView == nil) {
        _pulseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _pulseTableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
        _pulseTableView.showsVerticalScrollIndicator = NO;
        _pulseTableView.backgroundColor = [UIColor clearColor];
        _pulseTableView.dataSource = self;
        _pulseTableView.delegate = self;
    }
    return _pulseTableView;
}

#pragma mark - Private Methods

- (void)setup
{
    [self.contentView addSubview:self.pulseTableView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.superview == nil)
        return 0;
    
    if ([self.delegate respondsToSelector:@selector(pulseTableViewCellNumberOfRows:)] == YES)
        return [self.delegate pulseTableViewCellNumberOfRows:self];
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(pulseTableViewCell:pulseTableView:cellForRowAtIndexPath:)] == YES)
        return [self.delegate pulseTableViewCell:self pulseTableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSAssert1(NO, @"If you provided -tableViewTableViewCell:fromTableView:atIndexPathNumberOfRows: method you need to provide %@ as well", NSStringFromSelector(_cmd));
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(pulseTableViewCell:willDisplayCell:forRowAtIndexPath:)] == YES)
        [self.delegate pulseTableViewCell:self willDisplayCell:cell forRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(pulseTableViewCell:heightForRowAtIndexPath:)] == YES)
        return [self.delegate pulseTableViewCell:self heightForRowAtIndexPath:indexPath];
    
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(pulseTableViewCell:didSelectRowAtIndexPath:)])
        [self.delegate pulseTableViewCell:self didSelectRowAtIndexPath:indexPath];
}

#pragma mark - NGNinjaTableViewCellAppearing

- (void)willAppearInRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super willAppearInRowAtIndexPath:indexPath];
    
    // begin support for iOS < iOS 6.0
    if (kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_5_1) {
        if (self.previousIndexPath != nil)
            [self didDisappearFromRowAtIndexPath:self.previousIndexPath];
        self.previousIndexPath = indexPath;
    }
    // end support for iOS < iOS 6.0
}

- (void)didDisappearFromRowAtIndexPath:(NSIndexPath*)indexPath
{
    // if pulseTableView is develetaring, stop it immediatelly at current content offset
    if (self.pulseTableView.isDecelerating == YES)
        [self.pulseTableView setContentOffset:self.pulseTableView.contentOffset animated:NO];
    
    [super didDisappearFromRowAtIndexPath:indexPath];
}

@end
