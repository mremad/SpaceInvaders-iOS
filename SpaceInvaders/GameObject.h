//
//  GameObject.h
//  SpaceInvaders
//
//  Created by M on 11/27/13.
//  Copyright (c) 2013 M. All rights reserved.
//


#import <SpriteKit/SpriteKit.h>
#import "define.h"
/**
 Used to identify game object types and is used for object contacts and collisions.
 */



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

- (void)removeNodeWithEffectsAtContactPoint:(SKPhysicsContact*)contact;
-(void) removeNodeWithSmallerEffectsAtContactPoint:(SKPhysicsContact*)contact;

/**
 Creates the object with texture that represents this object and will be rendered on screen.
 */
+ (SKTexture *)createTexture;
+ (SKEmitterNode*)newExplosionEmitter;
+ (SKEmitterNode*)newFuelEmitter;
+ (SKEmitterNode *) newBulletEmitter;
+ (SKEmitterNode*)newSmokeEmitter;
+(BOOL) ContactAOrB:(SKPhysicsContact *)contact collidedWithStuff:(NSArray *) allPossibleContacts;


@end
