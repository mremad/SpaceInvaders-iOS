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
    
    BOOL freezeReady;
    BOOL automaticReady;
    BOOL sideBulletsReady;
    
    SKSpriteNode *sideBulletTimerSprite;
    SKSpriteNode *automaticTimerSprite;
    SKSpriteNode *freezeTimerSprite;
    SKSpriteNode *explodeTimerSprite;

    
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
        
        sideBulletsReady = YES;
        freezeReady = YES;
        automaticReady = YES;
        
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
    if(sideBullets || !sideBulletsReady)
        return;
    
    sideBullets = YES;
    sideBulletsReady = NO;
    
    sideBulletsTimer = [NSTimer scheduledTimerWithTimeInterval:(1/(sideBulletsRateofFire*1.0))
                                                              target:self
                                                            selector:@selector(sideBulletsRepeater)userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(sideBulletsFinished)
                                   userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(sideBulletsReady)
                                   userInfo:nil repeats:NO];
    
    
    sideBulletTimerSprite = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(65/2, 45/2)];
    sideBulletTimerSprite.position = CGPointMake(4+UpgradeSideBullets*4+UpgradeSideBullets*4+(UpgradeSideBullets*65/2), 7);
    sideBulletTimerSprite.anchorPoint = CGPointZero;
    sideBulletTimerSprite.alpha = 0.4;
    [sideBulletTimerSprite runAction:[SKAction scaleYTo:0 duration:30]];
    
    [_scene.layerUpgradeNode addChild:sideBulletTimerSprite];
}

-(void)sideBulletsReady
{
    sideBulletsReady = YES;
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
    if(freezeFired || !freezeReady)
        return;
    
    freezeFired = YES;
    freezeReady = NO;
    
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
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(freezeFinished) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:50.0 target:self selector:@selector(freezeReady) userInfo:nil repeats:NO];
    
    freezeTimerSprite = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(65/2, 45/2)];
    freezeTimerSprite.position = CGPointMake(4+UpgradeFreeze*4+UpgradeFreeze*4+(UpgradeFreeze*65/2), 7);
    freezeTimerSprite.anchorPoint = CGPointZero;
    freezeTimerSprite.alpha = 0.4;
    [freezeTimerSprite runAction:[SKAction scaleYTo:0 duration:50]];
    
    [_scene.layerUpgradeNode addChild:freezeTimerSprite];
    
}

-(void)freezeReady
{
    freezeReady = YES;
}
-(void)freezeFinished
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
        {
            [enemyShip removeNodeWithEffectsAtContactPoint:nil];
            [_scene increaseScoreBy:[enemyShip increaseScoreAmount]];
        }
    }
    
    [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(destroyAllEnemiesFinished:)
                                   userInfo:nil repeats:NO];
    
    explodeTimerSprite = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(65/2, 45/2)];
    explodeTimerSprite.position = CGPointMake(4+UpgradeDestroyAllEnemys*4+UpgradeDestroyAllEnemys*4+(UpgradeDestroyAllEnemys*65/2), 7);
    explodeTimerSprite.anchorPoint = CGPointZero;
    explodeTimerSprite.alpha = 0.4;
    [explodeTimerSprite runAction:[SKAction scaleYTo:0 duration:60]];
    
    [_scene.layerUpgradeNode addChild:explodeTimerSprite];
    
    destroyAllEnemiesFired = YES;
}

-(void)destroyAllEnemiesFinished:(NSTimer*)timer
{
    destroyAllEnemiesFired = NO;
}

-(void)activateAutomaticShooting
{
    if(automaticShoot || !automaticReady)
        return;
    
    automaticShoot = YES;
    automaticReady = NO;
    
    automaticShootingTimer = [NSTimer scheduledTimerWithTimeInterval:(1/(rateOfFire*1.0))
                                                              target:self
                                                                     selector:@selector(automaticShootingRepeater)userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(automaticShootingFinished)
                                   userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(automaticShootingReady)
                                   userInfo:nil repeats:NO];
    
    automaticTimerSprite = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(65/2, 45/2)];
    automaticTimerSprite.position = CGPointMake(4+UpgradeAutomaticShooting*4+UpgradeAutomaticShooting*4+(UpgradeAutomaticShooting*65/2), 7);
    automaticTimerSprite.anchorPoint = CGPointZero;
    automaticTimerSprite.alpha = 0.4;
    [automaticTimerSprite runAction:[SKAction scaleYTo:0 duration:30]];
    
    [_scene.layerUpgradeNode addChild:automaticTimerSprite];
    
}

-(void)automaticShootingReady
{
    automaticReady = YES;
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
