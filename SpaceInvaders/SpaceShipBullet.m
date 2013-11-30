//
//  SpaceShipBullet.m
//  SpaceInvaders
//
//  Created by M on 11/27/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "SpaceShipBullet.h"

@implementation SpaceShipBullet
- (id)initWithPosition:(CGPoint)position {
    
    if(self = [super initWithPosition:position]) {
        
        SKEmitterNode* bulletEmitter = [GameObject newBulletEmitter];
        bulletEmitter.position = CGPointMake(self.size.width/2, self.size.height);
        
        //Name the asteroid and reduce it's size to 70%--it looks about right.
        self.name = @"SpaceShipBullet";
        [self setSize:CGSizeMake(10, 50)];
        [self setColor:[UIColor clearColor]];
        [self setScale:0.25f];
        [self addChild:bulletEmitter];
        [self configureCollisionBody];
    }
    
    return self;
}

- (void)configureCollisionBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = CollisionTypeSpaceShipBullet;
    self.physicsBody.collisionBitMask = CollisionTypeEnemyXRuser;
    self.physicsBody.contactTestBitMask = CollisionTypeEnemyXRuser;
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