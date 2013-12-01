//
//  MyScene.h
//  SpaceInvaders
//

//  Copyright (c) 2013 M. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SpaceShip.h"
#import "Upgrade.h"
#import "SpaceShipBullet.h"
#import "EnemyShip.h"
#import "EnemyFactory.h"

@interface MyScene : SKScene<SKPhysicsContactDelegate>


/**
 the layerPlayerNode is the node that the spaceship is a member of
 */
@property (nonatomic, strong) SKNode *layerPlayerNode;

@property (nonatomic, strong) SKNode *layerSpaceShipBulletsNode;

@property (nonatomic, strong) SKNode *layerEnemiesNode;

@property (nonatomic, strong) SKNode* layerFirstBackground;
@property (nonatomic, strong) SKNode* layerSecondBackground;

@property BOOL gameRunning;

@end
