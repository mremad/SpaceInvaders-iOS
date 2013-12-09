//
//  UpgradeViewController.m
//  SpaceInvaders
//
//  Created by Mohamed Emad on 12/8/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "UpgradeViewController.h"

@interface UpgradeViewController ()

@property (strong, nonatomic) IBOutlet UILabel *playerBalanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *freezeCost;
@property (strong, nonatomic) IBOutlet UIButton *freezeBuy;
@property (strong, nonatomic) IBOutlet UILabel *sideCost;
@property (strong, nonatomic) IBOutlet UIButton *sideBuy;
@property (strong, nonatomic) IBOutlet UILabel *explodeCost;
@property (strong, nonatomic) IBOutlet UIButton *explodeBuy;
@property (strong, nonatomic) IBOutlet UILabel *automaticCost;
@property (strong, nonatomic) IBOutlet UIButton *automaticBuy;


@end

@implementation UpgradeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (IBAction)freezeBuy:(id)sender
{
    [_upgradeCenter purchaseUpgrade:UpgradeFreeze];
    [self updateView];
}
- (IBAction)sideBuy:(id)sender
{
    [_upgradeCenter purchaseUpgrade:UpgradeSideBullets];
    [self updateView];
}
- (IBAction)automaticBuy:(id)sender
{
    [_upgradeCenter purchaseUpgrade:UpgradeAutomaticShooting];
    [self updateView];
}
- (IBAction)explodeBuy:(id)sender
{
    [_upgradeCenter purchaseUpgrade:UpgradeDestroyAllEnemys];
    [self updateView];
}

-(void)updateView
{
    _playerBalanceLabel.text = [NSString stringWithFormat:@"Coins:%d",_upgradeCenter.playerBalance];
    
    _freezeCost.text = [NSString stringWithFormat:@"Cost:%d",COST_FREEZE];
    _sideCost.text = [NSString stringWithFormat:@"Cost:%d",COST_SIDE_BULLETS];
    _automaticCost.text = [NSString stringWithFormat:@"Cost:%d",COST_AUTOMATIC_SHOOTING];
    _explodeCost.text = [NSString stringWithFormat:@"Cost:%d",COST_DESTROY_ALL_ENEMIES];
    
    
    if(_upgradeCenter.upgradeList[UpgradeFreeze])
    {
        //_freezeBuy.titleLabel.text = @"-";
        _freezeBuy.enabled = FALSE;
    }
    
    if(_upgradeCenter.upgradeList[UpgradeSideBullets])
    {
        //_sideBuy.titleLabel.text = @"-";
        _sideBuy.enabled = FALSE;
    }
    
    if(_upgradeCenter.upgradeList[UpgradeAutomaticShooting])
    {
        //_automaticBuy.titleLabel.text = @"-";
        _automaticBuy.enabled = FALSE;
    }
    
    if(_upgradeCenter.upgradeList[UpgradeDestroyAllEnemys])
    {
        //_explodeBuy.titleLabel.text = @"-";
        _explodeBuy.enabled = FALSE;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor grayColor]];
    [self updateView];
    

    
}
- (IBAction)goBackToMain:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
