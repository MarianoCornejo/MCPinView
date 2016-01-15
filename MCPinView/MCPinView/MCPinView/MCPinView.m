//
//  MCPinView.m
//  AnotherTest
//
//  Created by Mariano Cornejo on 8/11/15.
//  Copyright (c) 2015 PLDevelop. All rights reserved.
//

#import "MCPinView.h"

@interface MCPinView()

@property (strong, nonatomic) NSMutableArray *fields;
@property (readwrite, nonatomic) NSInteger fieldLength;
@property (strong, nonatomic) UIView *slider;
@property (weak, nonatomic) MCPinTextField *currentPinTextField;
@property (assign, nonatomic) BOOL canBecomeFirstResponder;

@end

@implementation MCPinView

#pragma mark - Custom accesors


- (NSMutableArray *)fields{
    if (!_fields) {
        _fields = [[NSMutableArray alloc] init];
    }
    return _fields;
}

- (UIView *)slider {
    if (!_slider) {
        UITextField *firstField = [self.fields firstObject];
        _slider = [[UIView alloc] initWithFrame:CGRectMake(firstField.frame.origin.x, firstField.frame.origin.y + self.fieldsHeight + 1, self.fieldsWidth, 5)];
        _slider.backgroundColor = self.fieldsBorderColor;
    }
    return _slider;
}

#pragma mark - Public

- (void)failFlash {
    if (self.currentPinTextField == [self.fields lastObject]) {
        self.currentPinTextField.enabled = NO;
        [self failFlashAllPins:^{
            self.currentPinTextField.enabled = YES;
            [self restartSliderPosition];
        }];
    }
}

- (void)restartAll {
    for (MCPinTextField *pin in self.fields) {
        [pin clear];
    }
    [self restartSliderPosition];
}

#pragma mark - Private

- (MCPinTextField *)nextTextField:(MCPinTextField *)textField {
    NSInteger nextTag = textField.tag == self.fields.count ? 9999 : (textField.tag+1);
    if (nextTag != 9999) {
        MCPinTextField *nextTextField = (MCPinTextField *)[self viewWithTag:nextTag];
        return nextTextField;
    }
    return nil;
}

- (MCPinTextField *)previousTextField:(MCPinTextField *)textField {
    NSInteger previousTag = textField.tag == 1 ? 9999 : (textField.tag-1);
    if (previousTag != 9999) {
        MCPinTextField *previousTextField = (MCPinTextField *)[self viewWithTag:previousTag];
        return previousTextField;
    }
    return nil;
}

-(void)setUpFields{
    //validating values (dealing with funny guys)
    
    self.marginBetweenFields = (self.marginBetweenFields < 0)? 0:self.marginBetweenFields;
    self.fieldsNumber = (self.fieldsNumber < 0)? 0:self.fieldsNumber;
    self.fieldsWidth = (self.fieldsWidth < 0)? 0:self.fieldsWidth;
    self.fieldsHeight = (self.fieldsHeight < 0)? 0:self.fieldsHeight;
    
    //determining the valid width and height sizes for the fields
    CGFloat maxFieldWidth = (self.frame.size.width - (self.marginBetweenFields*(self.fieldsNumber-1)))/self.fieldsNumber;
    CGFloat maxFieldHeight = self.frame.size.height;
    
    if (self.fieldsWidth <= maxFieldWidth) {
        maxFieldWidth = self.fieldsWidth;
    }
    
    if (self.fieldsHeight <= maxFieldHeight) {
        maxFieldHeight = self.fieldsHeight;
    }
    
    //determining the position of the fields before be created
    CGFloat posAcum = 0;
    CGFloat posY = 0;
    if (self.centerContent) {
        CGFloat totalWidth = maxFieldWidth*self.fieldsNumber + (self.fieldsNumber -1)*self.marginBetweenFields;
        posAcum = self.frame.size.width/2 - totalWidth/2;
        
        posY = self.frame.size.height/2 - maxFieldHeight/2;
    }
    
    UIColor *fieldColor = self.fieldsColor ? self.fieldsColor : [UIColor clearColor];
    
    //create the fields
    for (int x=0;x<self.fieldsNumber;x++) {
        
        MCPinTextField *tf = [[MCPinTextField alloc] initWithFrame:CGRectMake(posAcum, posY, maxFieldWidth, maxFieldHeight)];
        posAcum = posAcum + self.marginBetweenFields + maxFieldWidth;
        tf.pinTextFieldDelegate = self;
        tf.pinBorderWidth = self.fieldsBorderWidth;
        tf.pinBorderColor = self.fieldsBorderColor;
        tf.pinFillColor = self.fieldsBorderColor;
        tf.pinFailColor = self.pinFailColor ? self.pinFailColor : [UIColor redColor];
        tf.pinCornerRadius = self.fieldsCornerRadius;
        tf.failFlashDuration = self.failFlashDuration;
        tf.backgroundColor = fieldColor;
        tf.tag = x+1;
        
        [self addSubview:tf];
        [self.fields addObject:tf];
    }
}

- (void)setUpPinView{
    if (self.backgroundImage) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:self.bounds];
        iv.image = self.backgroundImage;
        [self addSubview:iv];
    }
}

- (void)failFlashAllPins:(void (^)(void))completion {
    for (MCPinTextField *pin in self.fields) {
        [pin failFlash:^{
            [pin clear];
            if (completion) {
                completion();
            }
        }];
    }
}

- (void)restartSliderPosition {
    self.canBecomeFirstResponder = YES;
    MCPinTextField *pin = [self.fields firstObject];
    [pin becomeFirstResponder];
}

- (NSString *)retrievePinNumber {
    NSString *pinNumber = @"";
    for (MCPinTextField *textField in self.fields) {
        pinNumber = [NSString stringWithFormat:@"%@%@",pinNumber,textField.text];
    }
    pinNumber = [pinNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    return pinNumber;
}

#pragma mark - Override

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self setUpPinView];
    
    [self setUpFields];
    
    [self addSubview:self.slider];

    [self restartSliderPosition];
}

#pragma mark - MCPinTextFieldDelegate

- (void)mcPinTextFieldDidReachPinLength:(MCPinTextField *)pinTextField {
    self.canBecomeFirstResponder = YES;
    MCPinTextField *nextTextField = [self nextTextField:pinTextField];
    if (nextTextField) {
        [nextTextField becomeFirstResponder];
    } else {
        self.canBecomeFirstResponder = NO;
        if ([self.delegate respondsToSelector:@selector(mcPinViewDidEndFillingAll:pinNumber:)]) {
            NSString *pinNumber = [self retrievePinNumber];
            [self.delegate mcPinViewDidEndFillingAll:self pinNumber:pinNumber];
        }
    }
}

- (void)mcPinTextFieldDidEndErasePin:(MCPinTextField *)pinTextField {
    self.canBecomeFirstResponder = YES;
    MCPinTextField *previousTextField = [self previousTextField:pinTextField];
    if (previousTextField) {
        [previousTextField clear];
        [previousTextField becomeFirstResponder];
    }
}

- (void)mcPinTextFieldDidBeginEditing:(MCPinTextField *)pinTextField {
    self.canBecomeFirstResponder = NO;
    self.currentPinTextField = pinTextField;
    [UIView animateWithDuration:0.1 animations:^{
        self.slider.frame = CGRectMake(pinTextField.frame.origin.x, self.slider.frame.origin.y, self.slider.frame.size.width, self.slider.frame.size.height);
    }];
}

- (BOOL)mcPinTextFieldShouldBeginEditing:(MCPinTextField *)destinationTextField {
    if (self.canBecomeFirstResponder) {
        return YES;
    } else {
        return NO;
    }
}

@end
