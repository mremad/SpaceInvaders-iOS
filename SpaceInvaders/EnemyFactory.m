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
    return nil;
}

+(EnemyShip *)CreateEnemyXRuser
{
    EnemyShip *ship = [[XRuser alloc]initWithPosition:[self generateRandomAcceptablePoint]];
    SKAction *moveAction = [SKAction moveToY:-100 duration:8]; //TODO set appropiate numbers (duration and moveTo handle ultamately the speed.. .. used for the upgrade for ex)
    SKAction *removeEnemy= [SKAction removeFromParent];
    SKAction *enemySequence = [SKAction sequence:@[moveAction, removeEnemy]];
    [ship runAction:enemySequence];
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
