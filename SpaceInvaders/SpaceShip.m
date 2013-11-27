//
//  SpaceShip.m
//  SpaceInvaders
//
//  Created by M on 11/27/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "SpaceShip.h"

@implementation SpaceShip

- (id)initWithPosition:(CGPoint)position {
    
    if(self = [super initWithPosition:position]) {
        
        //Name the asteroid and reduce it's size to 70%--it looks about right.
        self.name = @"spaceShip";
        [self setScale:0.2f];
        [self configureCollisionBody];
    }
    
    return self;
}


- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact *)contact
{
    //if the SpaceShip collided with anything destory it 
        [self removeFromParent]; //TODO TEAM show Explosion
}


- (void)configureCollisionBody {
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = CollisionTypeSpaceShip;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionTypeEnemyXRuser;
}

+ (SKTexture *)createTexture {
    
    static SKTexture *texture = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        texture = [SKTexture textureWithImageNamed:@"Spaceship.png"];
        texture.filteringMode = SKTextureFilteringNearest;
        
    });
    
    return texture;
    
}
@end

