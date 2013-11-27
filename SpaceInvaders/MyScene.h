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

@interface MyScene : SKScene


/**
 the layerPlayerNode is the node that the spaceship is a member of
 */
@property (nonatomic, strong) SKNode *layerPlayerNode;

@property (nonatomic, strong) SKNode *layerSpaceShipBulletsNode;

@end
