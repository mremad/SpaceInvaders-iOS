//
//  MainMenuViewController.m
//  SpaceInvaders
//
//  Created by Mohamed Emad on 12/9/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "MainMenuViewController.h"
#import "AppDelegate.h"

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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    upgradeCenter = [[UpgradeCenter alloc] initWithScene:nil];
    upgradeCenter.playerBalance = 2000;
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

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
//

-(void)viewDidAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(appDelegate.navJumpToScore)
    {
        appDelegate.navJumpToScore=NO;
        ScoreViewController *svc = [[ScoreViewController alloc] init];
        [self.navigationController pushViewController:svc animated:YES];
    }
}


- (NSUInteger)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
