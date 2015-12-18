//
//  PinLoginViewController.m
//  MCPinView
//
//  Created by Mariano Cornejo on 12/18/15.
//  Copyright © 2015 MarianoCornejo. All rights reserved.
//

#import "PinLoginViewController.h"

@interface PinLoginViewController ()
@property (strong, nonatomic) NSString *currentPin;
@end

@implementation PinLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)currentPin {
    if (!_currentPin) {
        _currentPin = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"];
    }
    return _currentPin;
}

#pragma mark - MCPinViewDelegate

- (void)mcPinViewDidEndFillingAll:(MCPinView *)pinView pinNumber:(NSString *)pinNumber {
    if ([self.currentPin isEqualToString:pinNumber]) {
        NSLog(@"GOOD, pins are the same");
    } else {
        [pinView failFlash];
        NSLog(@"WRONG");
    }
    
}

@end
