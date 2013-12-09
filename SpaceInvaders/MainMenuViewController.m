//
//  MainMenuViewController.m
//  SpaceInvaders
//
//  Created by Mohamed Emad on 12/9/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()



@end

@implementation MainMenuViewController
{
    UpgradeCenter* upgradeCenter;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    upgradeCenter = [[UpgradeCenter alloc] initWithScene:nil];
    upgradeCenter.playerBalance = 1000;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if ([[segue identifier]
         isEqualToString:@"segueToUpgradeView"]){
        
        UpgradeViewController *viewController = [segue destinationViewController];
        viewController.upgradeCenter = upgradeCenter;
        
    }
    else if([[segue identifier] isEqualToString:@"Game"])
    {
        GameViewController *viewController = [segue destinationViewController];
        viewController.upgradeCenter = upgradeCenter;
    }
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
