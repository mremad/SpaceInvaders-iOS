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
#import "RandomGenerator.h"

@interface MyScene : SKScene<SKPhysicsContactDelegate>


/**
 the layerPlayerNode is the node that the spaceship is a member of
 */
@property (nonatomic, strong) SKEffectNode *layerPlayerNode;

@property (nonatomic, strong) SKNode *layerSpaceShipBulletsNode;

@property (nonatomic, strong) SKNode *layerEnemiesNode;

@property (nonatomic, strong) SKNode* layerFirstBackground;

@property (nonatomic, strong) SKNode* layerSecondBackground;

@property (nonatomic, strong) SKNode* starLayerNode;

@property (nonatomic, strong) SKNode* layerHudNode;

@property BOOL gameRunning;


/**
 Increases the score by the amount specified. The HUD layer will be updated to reflect the change.
 */
- (void)increaseScoreBy:(float)amount;
@end
