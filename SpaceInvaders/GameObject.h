//
//  GameObject.h
//  SpaceInvaders
//
//  Created by M on 11/27/13.
//  Copyright (c) 2013 M. All rights reserved.
//


#import <SpriteKit/SpriteKit.h>
#import "XTroyerDebris.h"

/**
 Used to identify game object types and is used for object contacts and collisions.
 */

typedef NS_OPTIONS(uint32_t, CollisionType) {
    CollisionTypeSpaceShip      = 1 << 0,
    CollisionTypeSpaceShipBullet   = 1 << 1,
    CollisionTypeEnemyXRuser     = 1 << 2,
    CollisionTypeEnemyXTroyer      = 1 << 3,
    CollisionTypeEnemyXStar      = 1 << 4,
    CollisionTypeEnemyBullet      = 1 << 5,
};

@interface GameObject : SKSpriteNode

/**
 The heading of the game object
 */
@property (assign, nonatomic) CGPoint heading;
/**
 The health of the game object.  Not all objects need to reduce or increase health
 */
@property (assign, nonatomic) float health;
/**
 The max health of the game object.  Not all objects need to reduce or increase health
 */
@property (assign, nonatomic) float maxHealth;

/**
 Instanciates the object with a basic set of functionality
 */
- (instancetype)initWithPosition:(CGPoint)position;
/**
 Called by MyScene's update method.
 */
- (void)update:(CFTimeInterval)timeSpan;
/**
 Configures the colission body for the game object
 */
- (void)configureCollisionBody;
/**
 Called when one game object colides with another game object
 */
- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact *)contact;

- (void)removeNodeWithEffectsAtContactPoint:(CGPoint)contactPoint;

/**
 Creates the object with texture that represents this object and will be rendered on screen.
 */
+ (SKTexture *)createTexture;
+ (SKEmitterNode*)newExplosionEmitter;
+ (SKEmitterNode*)newFuelEmitter;
+ (SKEmitterNode *) newBulletEmitter;


@end
