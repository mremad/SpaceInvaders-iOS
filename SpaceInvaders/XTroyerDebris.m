//
//  XTroyerDebris.m
//  SpaceInvaders
//
//  Created by Mohamed Emad on 11/30/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "XTroyerDebris.h"

@implementation XTroyerDebris

- (id)initWithPosition:(CGPoint)position atContactPoint:(CGPoint)contactPoint {
    
    if(self = [super init]) {
        
        //Name the asteroid and reduce it's size to 70%--it looks about right.
        self.position = position;
        self.name = @"EnemyXTroyerDebris";
        self.texture = [[self class] createTexture];
        self.size = self.texture.size;
        
        [self setScale:0.2f]; //TODO TEAM RAVI
        
        
        SKEmitterNode* fuelRight = [GameObject newFuelEmitter];
        fuelRight.emissionAngle = 1.57;
        fuelRight.position = CGPointMake(self.size.width/2 + 33,self.size.height-25);
        [self addChild:fuelRight];
        [self runAction:[self createActions:contactPoint]];
        
        [self configureCollisionBody];
    }
    
    return self;
}

-(SKAction*)createActions:(CGPoint)contactPoint
{
    SKAction* movingAction = [SKAction moveTo:CGPointMake(500, self.position.y+300) duration:3];
    SKAction* removeAction = [SKAction removeFromParent];
    SKAction* sequence = [SKAction sequence:[NSArray arrayWithObjects:movingAction,removeAction, nil]];
    
    return sequence;
}

- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact *)contact
{
    if(contact.bodyA.categoryBitMask == CollisionTypeEnemyXRuser || contact.bodyB.categoryBitMask == CollisionTypeEnemyXRuser
       ||contact.bodyA.categoryBitMask  == CollisionTypeSpaceShip || contact.bodyB.categoryBitMask  == CollisionTypeSpaceShip ||
         contact.bodyA.categoryBitMask  == CollisionTypeEnemyXTroyer || contact.bodyB.categoryBitMask  == CollisionTypeEnemyXTroyer)
    {
        [self removeAllActions];
        [self removeFromParent];

    }
}



- (void)configureCollisionBody {
    
    /*
     This asteroid will collide with the monkey, but will not move itself--it will push the monkey out of the way.  This is accomplished by setting the collisionBitMask to 0, but setting the contactTestBitMask to the monkey.
     */
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width-10, self.frame.size.height-20)];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = CollisionTypeSpaceShipBullet;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionTypeEnemyXRuser|CollisionTypeEnemyXTroyer|CollisionTypeEnemyXStar|CollisionTypeSpaceShip;
}

+ (SKTexture *)createTexture {
    
    static SKTexture *texture = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        texture = [SKTexture textureWithImageNamed:@"debrisRed_1.png"]; //TODO TEAM RAVI
        texture.filteringMode = SKTextureFilteringNearest;
        
    });
    
    return texture;
    
}


@end
