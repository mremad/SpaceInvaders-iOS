//
//  Upgrade.h
//  SpaceInvaders
//
//  Created by M on 11/27/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "MyScene.h"

#define COST_FREEZE                 250
#define COST_AUTOMATIC_SHOOTING     50
#define COST_DESTROY_ALL_ENEMIES    300
#define COST_SIDE_BULLETS           150

@interface UpgradeCenter : NSObject

//possible states of UpgradeValues
typedef enum
{
    UpgradeFreeze = 0,
    UpgradeAutomaticShooting,
    UpgradeSideBullets,
    UpgradeDestroyAllEnemys
    
    
    
} Upgrade;


-(BOOL)isAutomaticShootingActivated;
-(void)activateUpgrade:(Upgrade)upgrade;
-(BOOL)purchaseUpgrade:(Upgrade) upgrade;
-(NSDictionary*)getAllUpgrades;
- (id)initWithScene:(MyScene*)scene;

@property bool* upgradeList;

@property int playerBalance;

@property MyScene* scene;

@end
