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


@implementation NGTextFieldTableViewCell {
    UITextField *_textField;
}

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

#pragma mark - Overriden (NGNinjaTableViewCell)

- (id)internalStateData
{
    return _textField.text;
}

- (void)setInternalStateData:(id)data
{
    _textField.text = data;
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
    if ([self.delegate respondsToSelector:@selector(textFieldTableViewCellShouldBeginEditing:)] == NO)
        return YES;
    return [self.delegate textFieldTableViewCellShouldBeginEditing:self];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    
    if ([self.delegate respondsToSelector:@selector(textFieldTableViewCellDidBeginEditing:)] == YES)
        [self.delegate textFieldTableViewCellDidBeginEditing:self];
    
    [self notifyDelegateAboutBecamingFirstResponder];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldTableViewCellShouldEndEditing:)] == NO)
        return YES;
    return [self.delegate textFieldTableViewCellShouldEndEditing:self];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:textField];
    
    if ([self.delegate respondsToSelector:@selector(textFieldTableViewCellDidEndEditing:)] == YES)
        [self.delegate textFieldTableViewCellDidEndEditing:self];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.delegate respondsToSelector:@selector(textFieldTableViewCell:shouldChangeCharactersInRange:replacementString:)] == NO)
        return YES;
    return [self.delegate textFieldTableViewCell:self shouldChangeCharactersInRange:range replacementString:string];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldTableViewCellShouldClear:)] == NO)
        return YES;
    return [self.delegate textFieldTableViewCellShouldClear:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL shoudStayFirstResponder = NO;
    if ([self.delegate respondsToSelector:@selector(textFieldTableViewCellShouldStayFirstResponderOnReturn:)] == YES)
        shoudStayFirstResponder = [self.delegate textFieldTableViewCellShouldStayFirstResponderOnReturn:self];
    
    BOOL shouldReturn = YES;
    if ([self.delegate respondsToSelector:@selector(textFieldTableViewCellShouldReturn:)] == YES)
        shouldReturn = [self.delegate textFieldTableViewCellShouldReturn:self];

    if (shoudStayFirstResponder == NO) {
        [textField resignFirstResponder];
        [self notifyDelegateAboutResigningFirstResponder];
    }
    
    return shouldReturn;
}

#pragma mark - Notifications

- (void)textFieldTextDidChange:(NSNotification *)notification
{
    if ([self.delegate respondsToSelector:@selector(textFieldTableViewCellTextDidChange:)] == YES)
        [self.delegate textFieldTableViewCellTextDidChange:self];
}

@end
