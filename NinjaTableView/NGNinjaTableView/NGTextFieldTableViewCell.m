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

#import "NGTextFieldTableViewCell.h"


@interface NGTextFieldTableViewCell () <UITextFieldDelegate>
@end


@implementation NGTextFieldTableViewCell

#pragma mark - Public Properties

- (UITextField *)textField
{
    return _textField;
}

#pragma mark - Overriden

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeNGTextFieldTableViewCell];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeNGTextFieldTableViewCell];
    }
    return self;
}

#pragma mark - Overriden (NGResponderTableViewCell)

- (BOOL)becomeFirstResponder
{
    return [_textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [_textField resignFirstResponder];
}

#pragma mark - Private Methods

- (void)initializeNGTextFieldTableViewCell
{    
    _textField = [[UITextField alloc] init];
    _textField.translatesAutoresizingMaskIntoConstraints = NO;
    _textField.delegate = self;
    _textField.borderStyle = UITextBorderStyleLine;
    [self.contentView addSubview:_textField];
    
    NSDictionary * views = NSDictionaryOfVariableBindings(_textField);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_textField]-8-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_textField]-8-|" options:0 metrics:nil views:views]];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldTableViewCell:textFieldShouldBeginEditing:)] == NO)
        return YES;
    return [self.delegate textFieldTableViewCell:self textFieldShouldBeginEditing:textField];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    
    if ([self.delegate respondsToSelector:@selector(textFieldTableViewCell:textFieldDidBeginEditing:)] == YES)
        [self.delegate textFieldTableViewCell:self textFieldDidBeginEditing:textField];
    
    [self notifyDelegateAboutBecamingFirstResponder];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldTableViewCell:textFieldShouldEndEditing:)] == NO)
        return YES;
    return [self.delegate textFieldTableViewCell:self textFieldShouldEndEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:textField];
    
    if ([self.delegate respondsToSelector:@selector(textFieldTableViewCell:textFieldDidEndEditing:)] == YES)
        [self.delegate textFieldTableViewCell:self textFieldDidEndEditing:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.delegate respondsToSelector:@selector(textFieldTableViewCell:textField:shouldChangeCharactersInRange:replacementString:)] == NO)
        return YES;
    return [self.delegate textFieldTableViewCell:self textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldTableViewCell:textFieldShouldClear:)] == NO)
        return YES;
    return [self.delegate textFieldTableViewCell:self textFieldShouldClear:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL shouldReturn = NO;
    if ([self.delegate respondsToSelector:@selector(textFieldTableViewCell:textFieldShouldReturn:)] == YES)
        shouldReturn = [self.delegate textFieldTableViewCell:self textFieldShouldReturn:textField];

    if (shouldReturn == YES) {
        [textField resignFirstResponder];
        [self notifyDelegateAboutResigningFirstResponder];
    }
    
    return shouldReturn;
}

#pragma mark - Notifications

- (void)textFieldTextDidChange:(NSNotification *)notification
{
    if ([self.delegate respondsToSelector:@selector(textFieldTableViewCell:textFieldTextDidChange:)] == YES)
        [self.delegate textFieldTableViewCell:self textFieldTextDidChange:notification.object];
}

@end
