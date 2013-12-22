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
{
    SKLabelNode* scoreLabel;
}
- (id)initWithPosition:(CGPoint)position{
    
    if(self = [super initWithPosition:position]) {
        
        //Name the alien and reduce it's size to 70%--it looks about right.
        self.name = @"EnemyShip";
        _probabilityToShoot=0.01;
        [self setScale:0.02f];
        [self configureCollisionBody];
    }
    
    return self;
}

- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact *)contact
{
    NSArray *arrayToCheck =[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:CollisionTypeSpaceShip],[NSNumber numberWithInt:CollisionTypeSpaceShipBullet], [NSNumber numberWithInt:CollisionTypeDebrisBullet], nil];
    
    if([GameObject ContactAOrB:contact collidedWithStuff: arrayToCheck])
    {
        [(MyScene *)self.scene increaseScoreBy:[self increaseScoreAmount]];
        scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        scoreLabel.fontSize = 10.0;
        scoreLabel.text = [NSString stringWithFormat:@"+%1.0f",[self increaseScoreAmount]/10];
        scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        scoreLabel.position = self.position;
        [self.parent addChild:scoreLabel];
        
        SKAction * goUp = [SKAction moveTo:CGPointMake(self.position.x, self.position.y+100) duration:1.0];
        SKAction * removeFromParent = [SKAction removeFromParent];
        NSArray* sequence = [NSArray arrayWithObjects:goUp,removeFromParent,nil];

        [scoreLabel runAction:[SKAction sequence:sequence]];
        [scoreLabel runAction:[SKAction fadeAlphaTo:0 duration:0.75]];

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
