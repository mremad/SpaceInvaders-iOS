//
//  EnemyShip.m
//  SpaceInvaders
//
//  Created by M on 11/27/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "EnemyShip.h"

#import "MyScene.h"
//you can not instantiate Objects from EnemyShip!(it will lead to an Exception)
@implementation EnemyShip
- (id)initWithPosition:(CGPoint)position {
    
    if(self = [super initWithPosition:position]) {
        
        //Name the asteroid and reduce it's size to 70%--it looks about right.
        self.name = @"EnemyShip";
        [self setScale:0.02f];
        [self configureCollisionBody];
    }
    
    return self;
}

- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact *)contact
{
    if(contact.bodyA.categoryBitMask == CollisionTypeSpaceShipBullet || contact.bodyB.categoryBitMask == CollisionTypeSpaceShipBullet||contact.bodyA.categoryBitMask  == CollisionTypeSpaceShip || contact.bodyB.categoryBitMask  == CollisionTypeSpaceShip)
    {
        [(MyScene *)self.scene increaseScoreBy:[self increaseScoreAmount]];
        [self removeAllActions];
        [self removeNodeWithEffectsAtContactPoint:contact];
        
    }
}

- (float)increaseScoreAmount
{
    //if a class does not implement this method just return 0
    return 0;
}

- (void)configureCollisionBody
{
    [self doesNotRecognizeSelector:_cmd]; // without overriding this method, this method is not usable(As If abstract)
}

+ (SKTexture *)createTexture
{
   [self doesNotRecognizeSelector:_cmd]; // without overriding this method, this method is not usable(As If abstract)
    return nil;
    
}
@end
