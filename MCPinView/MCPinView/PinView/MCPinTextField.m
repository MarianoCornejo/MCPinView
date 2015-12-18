//
//  MCPinTextField.m
//  MCPinView
//
//  Created by Mariano Cornejo on 8/11/15.
//  Copyright (c) 2015 Mariano Cornejo. All rights reserved.
//

#import "MCPinTextField.h"

CGFloat const kFailFlashDuration = 0.3;

@interface MCPinTextField() <UITextFieldDelegate>

@property (assign, nonatomic) NSInteger pinLength;
@property (strong, nonatomic) UIColor *defaultTextColor;
@property (strong, nonatomic) UIColor *defaultBackgroundColor;

@end

@implementation MCPinTextField

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark - Private

- (void)setUp {
    self.delegate = self;
    self.textAlignment = NSTextAlignmentCenter;
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.borderStyle = UITextBorderStyleNone;
    if (!self.cursorEnabled) {
        self.tintColor = [UIColor clearColor];
    }
    self.pinLength = (self.pinType == kPinTypeDefault) ? 1 : 4;
    if (self.pinBorderColor && self.pinBorderWidth) {
        self.layer.borderWidth = self.pinBorderWidth;
        self.layer.borderColor = self.pinBorderColor.CGColor;
    }
    if (self.pinCornerRadius) {
        self.layer.cornerRadius = self.pinCornerRadius;
        self.layer.masksToBounds = YES;
    }
}

#pragma mark - Public

- (void)failFlash:(void (^)(void))completion {
    CGFloat duration = self.failFlashDuration ? self.failFlashDuration : kFailFlashDuration;

    self.layer.borderColor = self.pinFailColor.CGColor;
    [UIView animateWithDuration:duration animations:^{
        self.layer.backgroundColor = self.pinFailColor.CGColor;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:duration animations:^{
                self.layer.backgroundColor = self.defaultBackgroundColor.CGColor;
                self.layer.borderColor = self.pinBorderColor.CGColor;
            } completion:^(BOOL finished) {
                if (finished) {
                    if (completion) {
                        completion();
                    }
                }
            }];
        }
    }];
}

- (void)fill {
    self.defaultBackgroundColor = self.backgroundColor;
    self.layer.backgroundColor = self.pinFillColor.CGColor;
    self.defaultTextColor = self.textColor;
    self.textColor = [UIColor clearColor];
}

- (void)unFill {
    self.layer.backgroundColor = self.defaultBackgroundColor.CGColor;
    self.textColor = self.defaultTextColor;
}

- (void)clear {
    self.text = @"";
    [self unFill];
}

#pragma mark - Private

- (void)callReachPinLengthDelegate {
    if ([self.pinTextFieldDelegate respondsToSelector:@selector(mcPinTextFieldDidReachPinLength:)]) {
        [self.pinTextFieldDelegate mcPinTextFieldDidReachPinLength:self];
    }
}

- (void)callEndErasePinDelegate {
    if ([self.pinTextFieldDelegate respondsToSelector:@selector(mcPinTextFieldDidEndErasePin:)]) {
        [self.pinTextFieldDelegate mcPinTextFieldDidEndErasePin:self];
    }
}

#pragma mark - Override

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self setUp];
}

- (void)deleteBackward {
    [self callEndErasePinDelegate];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))
        return NO;
    if (action == @selector(select:))
        return NO;
    if (action == @selector(selectAll:))
        return NO;
    return [super canPerformAction:action withSender:sender];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *currStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    int len = (int)currStr.length;
    
    if (len < self.pinLength) {
        self.text = currStr;
        [self unFill];
    } else if (len == self.pinLength) {
        self.text = currStr;
        [self fill];
        [self callReachPinLengthDelegate];
    } else {
        [self callReachPinLengthDelegate];
    }
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.pinType != kPinTypeDefault) {
        [self unFill];
    } else {
        [self clear];
    }
    if ([self.pinTextFieldDelegate respondsToSelector:@selector(mcPinTextFieldDidBeginEditing:)]) {
        [self.pinTextFieldDelegate mcPinTextFieldDidBeginEditing:(MCPinTextField *)textField];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.pinTextFieldDelegate respondsToSelector:@selector(mcPinTextFieldShouldBeginEditing:)]) {
        return [self.pinTextFieldDelegate mcPinTextFieldShouldBeginEditing:(MCPinTextField *)textField];
    } else {
        return YES;
    }
}

@end
