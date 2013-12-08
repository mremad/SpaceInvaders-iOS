//
//  Upgrade.m
//  SpaceInvaders
//
//  Created by M on 11/27/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "UpgradeCenter.h"

@implementation UpgradeCenter
{
    
    BOOL freezeFired;
    BOOL destroyAllEnemiesFired;
    BOOL automaticShoot;
    BOOL sideBullets;
    
    
    int rateOfFire;
    NSTimer* automaticShootingTimer;
    
    int sideBulletsRateofFire;
    NSTimer* sideBulletsTimer;
}

- (id)initWithScene:(MyScene*)scene
{
    self = [super init];
    if(self!=nil)
    {
        self.scene = scene;
        freezeFired = NO;
        destroyAllEnemiesFired = NO;
        automaticShoot = NO;
        sideBullets = NO;
        _upgradeList = (bool*)malloc(4*sizeof(bool));
        for(int i = 0;i<4;i++)
            _upgradeList[i] = NO;
        
        _playerBalance = 0;
        rateOfFire = 5;
        sideBulletsRateofFire = 5;
    }
    return self;
}

-(BOOL)purchaseUpgrade:(Upgrade)upgrade
{
    BOOL purchaseSucc = NO;
    
    switch (upgrade) {
        case UpgradeFreeze:
            
            if(_playerBalance>=COST_FREEZE)
            {
                _playerBalance -= COST_FREEZE;
                purchaseSucc = YES;
            }
            
            break;
        case UpgradeDestroyAllEnemys:
            
            if(_playerBalance>=COST_DESTROY_ALL_ENEMIES)
            {
                _playerBalance -= COST_DESTROY_ALL_ENEMIES;
                purchaseSucc = YES;
            }
            
            break;
        case UpgradeAutomaticShooting:
            if(_playerBalance>=COST_AUTOMATIC_SHOOTING)
            {
                _playerBalance -= COST_AUTOMATIC_SHOOTING;
                purchaseSucc = YES;
            }
            break;
        case UpgradeSideBullets:
            if(_playerBalance>=COST_SIDE_BULLETS)
            {
                _playerBalance -= COST_SIDE_BULLETS;
                purchaseSucc = YES;
            }
            break;
        default:
            break;
    }

    if(purchaseSucc)
    {
        _upgradeList[upgrade] = YES;
    }
    
    return purchaseSucc;
    
}


-(void)activateUpgrade:(Upgrade)upgrade
{
    switch (upgrade) {
        case UpgradeFreeze:
            if(_upgradeList[UpgradeFreeze])
                [self activateFreeze];
            break;
        case UpgradeDestroyAllEnemys:
            if(_upgradeList[UpgradeDestroyAllEnemys])
                [self activateDestroyAllEnemies];
            break;
        case UpgradeAutomaticShooting:
            if(_upgradeList[UpgradeAutomaticShooting])
                [self activateAutomaticShooting];
            break;
        case UpgradeSideBullets:
            if(_upgradeList[UpgradeSideBullets])
                [self activateSideBullets];
            break;
        default:
            break;
    }
}

-(void)activateSideBullets
{
    if(sideBullets)
        return;
    
    sideBullets = YES;
    
    sideBulletsTimer = [NSTimer scheduledTimerWithTimeInterval:(1/(sideBulletsRateofFire*1.0))
                                                              target:self
                                                            selector:@selector(sideBulletsRepeater)userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(sideBulletsFinished)
                                   userInfo:nil repeats:NO];
    
}

-(void)sideBulletsRepeater
{
    [_scene shootSideBullets];
}

-(void)sideBulletsFinished
{
    
    [sideBulletsTimer invalidate];
    sideBulletsTimer = nil;
    sideBullets = NO;
    
}


-(void)activateFreeze
{
    if(freezeFired)
        return;
    
    freezeFired = YES;
    _scene.layerEnemiesNode.speed = 0.01;
    CGSize size = CGSizeMake(_scene.size.width*2, _scene.size.height*2);
    SKSpriteNode* blueSprite = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0 green:177 blue:228 alpha:1] size:size];
    blueSprite.alpha = 0;
    blueSprite.position = CGPointMake(0, 0);
    [_scene addChild:blueSprite];
    SKAction* flash1 = [SKAction fadeAlphaTo:0.1 duration:0.4];
    SKAction* flash2 = [SKAction fadeAlphaTo:0 duration:0.7];
    SKAction* removeParent = [SKAction removeFromParent];
    NSArray* sequence= [NSArray arrayWithObjects:flash1,flash2,removeParent, nil];
    [blueSprite runAction:[SKAction sequence:sequence]];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(freezeFinished:) userInfo:nil repeats:NO];
    
}
-(void)freezeFinished:(NSTimer*)timer
{
    _scene.layerEnemiesNode.speed = 1;
    freezeFired = NO;
}

-(void)activateDestroyAllEnemies
{
    if(destroyAllEnemiesFired)
        return;
    for(EnemyShip* enemyShip in _scene.layerEnemiesNode.children)
    {
        if([enemyShip isKindOfClass:[EnemyShipDebris class]])
            [enemyShip removeNodeWithSmallerEffectsAtContactPoint:nil];
        else if([enemyShip isKindOfClass:[EnemyShip class]])
            [enemyShip removeNodeWithEffectsAtContactPoint:nil];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(destroyAllEnemiesFinished:)
                                   userInfo:nil repeats:NO];
    
    destroyAllEnemiesFired = YES;
}

-(void)destroyAllEnemiesFinished:(NSTimer*)timer
{
    destroyAllEnemiesFired = NO;
}

-(void)activateAutomaticShooting
{
    if(automaticShoot)
        return;
    
    automaticShoot = YES;
    
    automaticShootingTimer = [NSTimer scheduledTimerWithTimeInterval:(1/(rateOfFire*1.0))
                                                              target:self
                                                                     selector:@selector(automaticShootingRepeater)userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(automaticShootingFinished)
                                   userInfo:nil repeats:NO];
    
}

-(void)automaticShootingRepeater
{
    [_scene shootBullet];
}

-(void)automaticShootingFinished
{
    
    [automaticShootingTimer invalidate];
    automaticShootingTimer = nil;
    automaticShoot = NO;
    
}

-(BOOL)isAutomaticShootingActivated
{
    return automaticShoot;
}

-(NSDictionary*)getAllUpgrades
{
    return nil;
}



@end
