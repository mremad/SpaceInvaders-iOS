//
//  XTroyerDebris.m
//  SpaceInvaders
//
//  Created by Mohamed Emad on 11/30/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "EnemyShipDebris.h"

@implementation EnemyShipDebris

- (id)initWithPosition:(CGPoint)position withContact:(SKPhysicsContact *)contact {
    
    if(self = [super initWithPosition:position]) {
        
        self.name = @"EnemyShipDebris";

        
        [self setScale:0.2f];
        [self runAction:[self createActions:contact]];
        
        //SKEmitterNode* smoke = [GameObject newExplosionEmitter];
        //smoke.emissionAngle = 1.57;
        //smoke.position = CGPointMake(self.size.width/2,self.size.height/2);
        //[self addChild:smoke];
        
        [self runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:2]]];
        [self configureCollisionBody];
        
    }
    
    return self;
}

-(SKAction*)createActions:(SKPhysicsContact*)contact
{
    SKPhysicsBody* body;
    
    if(contact.bodyA.collisionBitMask == CollisionTypeSpaceShipBullet)
        body = contact.bodyA;
    else if(contact.bodyB.collisionBitMask == CollisionTypeSpaceShipBullet)
        body = contact.bodyB;
    
    int x1,x2,y1,y2,a,b,moveToX,moveToY,distanceTraveled;
    
    x1 = self.position.x;
    y1 = self.position.y;
    x2 = contact.contactPoint.x;
    y2 = contact.contactPoint.y;
    
    a = (y2 - y1)/(1.0*(x2-x1));
    b = ((y1*x2)-(y2*x1))/(1.0*(x2-x1));
    
    if(contact.contactPoint.x < self.position.x)
    {
        moveToX = 1000;
        moveToY = a*moveToX + b;
        distanceTraveled = sqrt(pow(moveToX - self.position.x,2)+pow(self.position.y-moveToY,2));
    }
    else
    {
        moveToX = -1000;
        moveToY = a*moveToX + b;
        distanceTraveled = sqrt(pow(moveToX + self.position.x,2)+pow(self.position.y-moveToY,2));
    }
    
    SKAction* movingAction = [SKAction moveTo:CGPointMake(moveToX, moveToY) duration:distanceTraveled/50.0];
    SKAction* removeAction = [SKAction removeFromParent];
    SKAction* sequence = [SKAction sequence:[NSArray arrayWithObjects:movingAction,removeAction, nil]];
    
    return sequence;
}

- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact *)contact
{
    NSArray *arrayToCheck =[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:CollisionTypeEnemyXRuser],[NSNumber numberWithInt:CollisionTypeSpaceShip],[NSNumber numberWithInt:CollisionTypeEnemyXTroyer], [NSNumber numberWithInt:CollisionTypeSpaceShipBullet],[NSNumber numberWithInt:CollisionTypeDebrisBullet], nil];
    
    if([GameObject ContactAOrB:contact collidedWithStuff: arrayToCheck])
    {
        [self generateSmallExplosionIfBulletFromSpaceShip:contact];
        [self removeAllActions];
        [self removeFromParent];
    }
}


-(void) generateSmallExplosionIfBulletFromSpaceShip:(SKPhysicsContact *) contact
{
       NSArray *arrayToCheck =[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:CollisionTypeSpaceShip] ,[NSNumber numberWithInt:CollisionTypeSpaceShipBullet], nil];
      if([GameObject ContactAOrB:contact collidedWithStuff: arrayToCheck])
        {
            [self removeNodeWithSmallerEffectsAtContactPoint:contact];
        }
}


- (void)configureCollisionBody {
    
    /*
     This alien will collide with the Spaceship, but will not move itself--it will push the Spaceship out of the way.  This is accomplished by setting the collisionBitMask to 0, but setting the contactTestBitMask to the Spaceship.
     */
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width-10, self.frame.size.height-20)];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = CollisionTypeDebrisBullet;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionTypeEnemyXRuser|CollisionTypeEnemyXTroyer|CollisionTypeEnemyXStar|CollisionTypeSpaceShip|CollisionTypeSpaceShipBullet;
}

+ (SKTexture *)createTexture {
    
      [self doesNotRecognizeSelector:_cmd]; // without overriding this method, this method is not usable(As If abstract)
    
    return nil;
    
}


@end
