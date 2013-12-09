//
//  ViewController.h
//  SpaceInvaders
//

//  Copyright (c) 2013 M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>
#import "UpgradeCenter.h"

@interface GameViewController : UIViewController

@property UpgradeCenter* upgradeCenter;
@property (strong, nonatomic) CMMotionManager *motionManager;

@end
