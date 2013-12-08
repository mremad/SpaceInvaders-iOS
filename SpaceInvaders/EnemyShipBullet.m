//
//  EnemyShipBullet.m
//  SpaceInvaders
//
//  Created by M on 12/4/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "EnemyShipBullet.h"

@implementation EnemyShipBullet
- (id)initWithPosition:(CGPoint)position {
    
    if(self = [super initWithPosition:position]) {
        
        _emitter = [GameObject newEnemyBulletEmitter];
        _emitter.position = CGPointMake(self.size.width/2, self.size.height);
        _emitter.particleColor = [UIColor redColor];
        _emitter.particleColorRedRange = 10;
        
        //Name the alien and reduce it's size to 70%--it looks about right.
        self.name = @"EnemyShipBullet";
        [self setSize:CGSizeMake(10, 50)];
        [self setColor:[UIColor clearColor]];
        [self setScale:0.25f];
        [self addChild:_emitter];
        [self configureCollisionBody];
    }
    
    return self;
}

- (void)configureCollisionBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = CollisionTypeEnemyBullet;
    self.physicsBody.collisionBitMask = CollisionTypeSpaceShip;
    self.physicsBody.contactTestBitMask = CollisionTypeSpaceShip;
}

- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact *)contact
{
    [self removeFromParent]; //if the bullet collided with anything remove the bullet
}

//Remove to add bullet texture

/*
 + (SKTexture *)createTexture {
 
 static SKTexture *texture = nil;
 static dispatch_once_t onceToken;
 dispatch_once(&onceToken, ^{
 
 texture = [SKTexture textureWithImageNamed:@"silvercoin.jpg"];
 texture.filteringMode = SKTextureFilteringNearest;
 
 });
 
 return texture;
 
 }*/

@end