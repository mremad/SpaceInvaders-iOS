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
        [self setScale:0.03f];
        [self configureCollisionBody];
    }
    
    return self;
}



- (void)configureCollisionBody {
    
    /*
     This asteroid will collide with the monkey, but will not move itself--it will push the monkey out of the way.  This is accomplished by setting the collisionBitMask to 0, but setting the contactTestBitMask to the monkey.
     */
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = CollisionTypeSpaceShip;
    self.physicsBody.collisionBitMask = CollisionTypeEnemyA | CollisionTypeEnemyB | CollisionTypeEnemyBullet | CollisionTypeEnemyC;
    self.physicsBody.contactTestBitMask = CollisionTypeEnemyA | CollisionTypeEnemyB | CollisionTypeEnemyBullet | CollisionTypeEnemyC;
}

+ (SKTexture *)createTexture {
    
    static SKTexture *texture = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        texture = [SKTexture textureWithImageNamed:@"goldcoin.jpg"];
        texture.filteringMode = SKTextureFilteringNearest;
        
    });
    
    return texture;
    
}
@end
