//
//  OptionsViewController.m
//  SpaceInvaders
//
//  Created by M on 12/9/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "OptionsViewController.h"
#import "AppDelegate.h"
@interface OptionsViewController ()

@end

@implementation OptionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)TiltingValueChanged:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(_TiltingOutLet.isOn)
    {
        appDelegate.tilting=YES;
    }
    else
    {
        appDelegate.tilting=NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
