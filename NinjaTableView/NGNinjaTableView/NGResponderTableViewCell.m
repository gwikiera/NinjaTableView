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

#import "NGResponderTableViewCell.h"


@implementation NGResponderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeNGResponderTableViewCell];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeNGResponderTableViewCell];
    }
    return self;
}

#pragma mark - Instance Methods

- (void)notifyDelegateAboutBecamingFirstResponder
{
    if ([self.delegate respondsToSelector:@selector(responderTableViewCellWillBecomeFirstResponder:)] == YES)
        [self.delegate responderTableViewCellWillBecomeFirstResponder:self];
}

- (void)notifyDelegateAboutResigningFirstResponder
{
    if ([self.delegate respondsToSelector:@selector(responderTableViewCellDidResignFirstResponder:)] == YES)
        [self.delegate responderTableViewCellDidResignFirstResponder:self];
}

#pragma mark - Overriden

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected == YES && self.becamesFirstResponderIfSelected == YES)
        [self becomeFirstResponder];
    if (selected == NO && self.resignsFirstResponderIfDeselected == YES)
        [self resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    return NO;
}

- (BOOL)resignFirstResponder
{
    return NO;
}

#pragma mark - Private Methods

- (void)initializeNGResponderTableViewCell
{
    _becamesFirstResponderIfSelected = YES;
    _resignsFirstResponderIfDeselected = YES;
}

@end
