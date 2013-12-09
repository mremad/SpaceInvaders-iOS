//
//  ViewController.m
//  SpaceInvaders
//
//  Created by M on 11/26/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "GameViewController.h"

#import "MyScene.h"
#import "ScoreViewController.h"

@implementation GameViewController
{
    MyScene* scene;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene.
    scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [scene setUpgradeCenter:self.upgradeCenter];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:scene
                                            action:@selector(handleSingleTap:)];
    
    [skView addGestureRecognizer:singleFingerTap];
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .2;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        [scene moveShipWithxStep:accelerometerData.acceleration.x yStep:accelerometerData.acceleration.y];
    }];
    
    // Present the scene.
    [skView presentScene:scene];
    
    //Registering for notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventListenerDidReceiveNotification:)
                                                 name:@"GameComplete"
                                               object:nil];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

- (NSUInteger)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//Getting information on SpaceShip Destruction
- (void)eventListenerDidReceiveNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"GameComplete"])
    {
        NSLog(@"Poof!");


    }
}@end
