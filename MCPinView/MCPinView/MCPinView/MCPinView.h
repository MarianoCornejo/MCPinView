//
//  MCPinView.h
//  MCPinView
//
//  Created by Mariano Cornejo on 8/11/15.
//  Copyright (c) 2015 Belatrix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCPinTextField.h"
@class MCPinView;

typedef NS_ENUM(NSInteger, MCPinViewType){
    /*! Default type is used to security pins*/
    MCPinViewTypeDefault = 0,
    /*! Card type is used to credit cards*/
    MCPinViewTypeCard
};

@protocol MCPinViewDelegate <NSObject>

- (void)mcPinViewDidEndFillingAll:(MCPinView *)pinView pinNumber:(NSString *)pinNumber;

@end

IB_DESIGNABLE @interface MCPinView : UIView <MCPinTextFieldDelegate>

@property (weak, nonatomic) IBOutlet id<MCPinViewDelegate> delegate;

@property (assign, nonatomic) MCPinViewType pinType;

@property (strong, nonatomic) IBInspectable UIImage *backgroundImage;

@property (assign, nonatomic) IBInspectable NSInteger fieldsNumber;
@property (assign, nonatomic) IBInspectable CGFloat fieldsWidth;
@property (assign, nonatomic) IBInspectable CGFloat fieldsHeight;
@property (assign, nonatomic) IBInspectable CGFloat marginBetweenFields;
@property (strong, nonatomic) IBInspectable UIColor *fieldsColor;
@property (assign, nonatomic) IBInspectable NSInteger fieldsBorderWidth;
@property (strong, nonatomic) IBInspectable UIColor *fieldsBorderColor;
@property (assign, nonatomic) IBInspectable CGFloat fieldsCornerRadius;
@property (strong, nonatomic) IBInspectable UIImage *fieldsBackgroundImage;
@property (strong, nonatomic) IBInspectable UIColor *pinFailColor;
@property (assign, nonatomic) IBInspectable CGFloat failFlashDuration;
@property (assign, nonatomic) IBInspectable BOOL centerContent;

- (void)failFlash;
- (void)restartAll;
@end
