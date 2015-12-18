//
//  MCPinTextField.h
//  MCPinView
//
//  Created by Mariano Cornejo on 8/11/15.
//  Copyright (c) 2015 Mariano Cornejo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCPinTextField;

typedef NS_ENUM(NSInteger, kPinType){
    kPinTypeDefault = 0,
    kPinTypeCard
};

@protocol MCPinTextFieldDelegate <NSObject>

- (void)mcPinTextFieldDidReachPinLength:(MCPinTextField *)pinTextField;
- (void)mcPinTextFieldDidEndErasePin:(MCPinTextField *)pinTextField;

@optional
- (void)mcPinTextFieldDidBeginEditing:(MCPinTextField *)pinTextField;
- (BOOL)mcPinTextFieldShouldBeginEditing:(MCPinTextField *)pinTextField;
@end

IB_DESIGNABLE @interface MCPinTextField : UITextField

@property (weak, nonatomic) id<MCPinTextFieldDelegate> pinTextFieldDelegate;

@property (assign, nonatomic) kPinType pinType;

@property (strong, nonatomic) IBInspectable UIColor *pinFillColor;
@property (strong, nonatomic) IBInspectable UIColor *pinFailColor;
@property (strong, nonatomic) IBInspectable UIColor *pinBorderColor;

@property (assign, nonatomic) IBInspectable CGFloat pinCornerRadius;
@property (assign, nonatomic) IBInspectable NSInteger pinBorderWidth;

@property (assign, nonatomic) IBInspectable BOOL cursorEnabled;
@property (assign, nonatomic) IBInspectable CGFloat failFlashDuration;

- (void)failFlash:(void (^)(void))completion;
- (void)fill;
- (void)unFill;
- (void)clear;

@end
