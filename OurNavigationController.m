//
//  OurNavigationController.m
//  SpaceInvaders
//
//  Created by M on 12/9/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "OurNavigationController.h"
#import "ScoreViewController.h"
#import "AppDelegate.h"
@interface OurNavigationController ()

@end

@implementation OurNavigationController

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
    
    UIViewController *rootViewController = self.viewControllers[0];
    if([self.visibleViewController isEqual:rootViewController])
    {
        [self setNavigationBarHidden:YES animated:NO];
    }
	// Do any additional setup after loading the view.
}

-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    UIViewController *rootViewController = self.viewControllers[0];
    if([self.visibleViewController isEqual:rootViewController])
    {
        [self setNavigationBarHidden:YES animated:NO];
    }
    else
    {
        [self setNavigationBarHidden:NO animated:NO];
    }
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
