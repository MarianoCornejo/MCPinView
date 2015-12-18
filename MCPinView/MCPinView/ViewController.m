//
//  ViewController.m
//  MCPinView
//
//  Created by Mariano Cornejo on 12/18/15.
//  Copyright © 2015 MarianoCornejo. All rights reserved.
//

#import "ViewController.h"

NSString * const kShowLoginSegueIdentifier = @"showLoginSegue";

@interface ViewController ()
@property (strong, nonatomic) NSString *currentPin;
@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.pinView restartAll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MCPinViewDelegate

- (void)mcPinViewDidEndFillingAll:(MCPinView *)pinView pinNumber:(NSString *)pinNumber {
    if (self.currentPin == nil) {//first time
        self.currentPin = pinNumber;
        [pinView restartAll];
    } else {
        if ([self.currentPin isEqualToString:pinNumber]) {
            //this should happen the second time user enter a pin and the pins are the same
            [[NSUserDefaults standardUserDefaults] setObject:self.currentPin forKey:@"pin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.currentPin = nil;
            [pinView restartAll];
            [self performSegueWithIdentifier:kShowLoginSegueIdentifier sender:nil];
        } else {
            // this should happen if is the second time that a user enter a pin but is different for the first time
            self.currentPin = nil;
            [pinView failFlash];
            NSLog(@"wrong pin , set pin again");
        }
    }
    
}

@end
