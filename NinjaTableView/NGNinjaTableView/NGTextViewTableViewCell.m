/*
 * Copyright (c) 2013 Wojciech Nagrodzki
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

#import "NGTextViewTableViewCell.h"


@interface NGTextViewTableViewCell () <UITextViewDelegate>
@end


@implementation NGTextViewTableViewCell

#pragma mark - Public Properties

- (UITextView *)textView
{
    return _textView;
}

#pragma mark - Overriden

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeNGTextViewTableViewCell];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeNGTextViewTableViewCell];
    }
    return self;
}

#pragma mark - Overriden (NGResponderTableViewCell)

- (BOOL)becomeFirstResponder
{
    return [self.textView becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [self.textView resignFirstResponder];
}

#pragma mark - Private Methods

- (void)initializeNGTextViewTableViewCell
{    
    _textView = [[UITextView alloc] init];
    _textView.translatesAutoresizingMaskIntoConstraints = NO;
    _textView.delegate = self;
    [self.contentView addSubview:_textView];
    
    NSDictionary * views = NSDictionaryOfVariableBindings(_textView);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_textView]-8-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_textView]-8-|" options:0 metrics:nil views:views]];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textViewTableViewCell:textViewShouldBeginEditing:)] == NO)
        return YES;
    
    return [self.delegate textViewTableViewCell:self textViewShouldBeginEditing:textView];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textViewTableViewCell:textViewShouldEndEditing:)] == NO)
        return YES;
    
    return [self.delegate textViewTableViewCell:self textViewShouldEndEditing:textView];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textViewTableViewCell:textViewDidBeginEditing:)] == YES)
        [self.delegate textViewTableViewCell:self textViewDidBeginEditing:textView];
    
    [self notifyDelegateAboutBecamingFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textViewTableViewCell:textViewDidEndEditing:)] == YES)
        [self.delegate textViewTableViewCell:self textViewDidEndEditing:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(textViewTableViewCell:textView:shouldChangeTextInRange:replacementText:)] == NO)
        return YES;
    
    return [self.delegate textViewTableViewCell:self textView:textView shouldChangeTextInRange:range replacementText:text];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textViewTableViewCell:textViewDidChange:)] == YES)
        [self.delegate textViewTableViewCell:self textViewDidChange:textView];
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (self.superview == nil)
        return;
    
    if ([self.delegate respondsToSelector:@selector(textViewTableViewCell:textViewDidChangeSelection:)] == YES)
        [self.delegate textViewTableViewCell:self textViewDidChangeSelection:textView];
}

@end
