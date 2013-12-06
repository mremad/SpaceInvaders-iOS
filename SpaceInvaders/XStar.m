//
//  XStar.m
//  SpaceInvaders
//
//  Created by M on 11/27/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "XStar.h"

@implementation XStar
- (id)initWithPosition:(CGPoint)position {
    
    if(self = [super initWithPosition:position]) {
        
        //Name the alien and reduce it's size to 70%--it looks about right.
        self.name = @"EnemyXStar";
        [self setScale:0.2f]; //TODO TEAM RAVI 
        [self configureCollisionBody];
    }
    
    return self;
}

- (float)increaseScoreAmount
{
    return 50;
}

- (void)configureCollisionBody {
    
    /*
     This alien will collide with the Spaceship, but will not move itself--it will push the Spaceship out of the way.  This is accomplished by setting the collisionBitMask to 0, but setting the contactTestBitMask to the Spaceship.
     */
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = CollisionTypeEnemyXStar;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionTypeSpaceShipBullet|CollisionTypeSpaceShip;
}

+ (SKTexture *)createTexture {
    
    static SKTexture *texture = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        texture = [SKTexture textureWithImageNamed:@"XBooster.png"]; //TODO TEAM RAVI
        texture.filteringMode = SKTextureFilteringNearest;
        
    });
    
    return texture;
    
}
@end