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

#import "NGResponderTableViewCell.h"

@class NGTextFieldTableViewCell;


@protocol NGTextFieldTableViewCellDelegate <NSObject, NGResponderTableViewCellDelegate>

@optional

- (BOOL)textFieldTableViewCellShouldBeginEditing:(NGTextFieldTableViewCell *)textFieldTableViewCell;        // return NO to disallow editing.
- (void)textFieldTableViewCellDidBeginEditing:(NGTextFieldTableViewCell *)textFieldTableViewCell;           // became first responder
- (BOOL)textFieldTableViewCellShouldEndEditing:(NGTextFieldTableViewCell *)textFieldTableViewCell;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldTableViewCellDidEndEditing:(NGTextFieldTableViewCell *)textFieldTableViewCell;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (BOOL)textFieldTableViewCell:(NGTextFieldTableViewCell *)textFieldTableViewCell shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
- (BOOL)textFieldTableViewCellShouldClear:(NGTextFieldTableViewCell *)textFieldTableViewCell;               // called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldTableViewCellShouldReturn:(NGTextFieldTableViewCell *)textFieldTableViewCell;              // called when 'return' key pressed. return NO to ignore.a
- (void)textFieldTableViewCellTextDidChange:(NGTextFieldTableViewCell *)textFieldTableViewCell;
- (BOOL)textFieldTableViewCellShouldStayFirstResponderOnReturn:(NGTextFieldTableViewCell *)textFieldTableViewCell;    //

@end


@interface NGTextFieldTableViewCell : NGResponderTableViewCell

@property (strong, nonatomic, readonly) UITextField * textField;

@end
