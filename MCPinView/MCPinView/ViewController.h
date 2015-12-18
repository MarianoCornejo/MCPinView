//
//  ViewController.h
//  MCPinView
//
//  Created by Mariano Cornejo on 12/18/15.
//  Copyright © 2015 MarianoCornejo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCPinView.h"

@interface ViewController : UIViewController<MCPinViewDelegate>

@property (weak, nonatomic) IBOutlet MCPinView *pinView;

@end

