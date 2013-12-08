//
//  MyScene.h
//  SpaceInvaders
//

//  Copyright (c) 2013 M. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SpaceShip.h"
#import "SpaceShipBullet.h"
#import "EnemyShip.h"
#import "EnemyFactory.h"
#import "RandomGenerator.h"
NSMutableArray *storedScores;

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

@property (nonatomic, strong) SKNode* layerUpgradeNode;

@property BOOL gameRunning;


/**
 Increases the score by the amount specified. The HUD layer will be updated to reflect the change.
 */
- (void)shootSideBullets;
- (void)shootBullet;
- (void)increaseScoreBy:(float)amount;
- (void)handleSingleTap:(UIGestureRecognizer*)ges;
@end
