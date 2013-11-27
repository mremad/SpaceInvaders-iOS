//
//  EnemyFactory.m
//  SpaceInvaders
//
//  Created by M on 11/27/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "EnemyFactory.h"

@implementation EnemyFactory


+ (EnemyFactory *)sharedFactory {
    static EnemyFactory *sharedFactory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFactory = [[self alloc] init];
    });
    return sharedFactory;
}


+(EnemyShip *)CreateSingleRandomEnemy
{
    int modulo3Number = arc4random()%3;
    switch (modulo3Number) {
        case 0:
            return [self CreateEnemyXRuser];
            break;
        case 1:
            return [self CreateEnemyXTroyer];
            break;
        default:
            return [self CreateEnemyXStar];
    }
}

+(SKAction *) normalEnemyBehaviour
{
    SKAction *moveAction = [SKAction moveToY:-100 duration:8]; //TODO set appropiate numbers (duration and moveTo handle ultamately the speed.. .. used for the upgrade for ex)
    SKAction *removeEnemy= [SKAction removeFromParent];
    SKAction *enemySequence = [SKAction sequence:@[moveAction, removeEnemy]];
    return enemySequence;
    
}

+(EnemyShip *)CreateEnemyXRuser
{
    EnemyShip *ship = [[XRuser alloc]initWithPosition:[self generateRandomAcceptablePoint]];
    [ship runAction:[self normalEnemyBehaviour]];
    return ship;
}

+(EnemyShip *)CreateEnemyXTroyer
{
    EnemyShip *ship = [[XTroyer alloc]initWithPosition:[self generateRandomAcceptablePoint]];
    [ship runAction:[self normalEnemyBehaviour]];
    return ship;
}

+(EnemyShip *)CreateEnemyXStar
{
    EnemyShip *ship = [[XStar alloc]initWithPosition:[self generateRandomAcceptablePoint]];
    [ship runAction:[self normalEnemyBehaviour]];
    return ship;
}

+(CGPoint) generateRandomAcceptablePoint
{
    int Ymin = 300;
    int Ymax = 600;
    int YInBetween=Ymin+(arc4random()%(Ymax-Ymin));
    
    int Xmin = 20;
    int Xmax =300;
    int XInBetween=Xmin+(arc4random()%(Xmax-Xmin));
    return CGPointMake(XInBetween, YInBetween);
}


- (id)init
{
    if (self = [super init])
    {
        _someProperty = @"DefaultPropertyValue";
    }
    return self;
}

@end
