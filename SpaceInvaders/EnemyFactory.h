//
//  EnemyFactory.h
//  SpaceInvaders
//
//  Created by M on 11/27/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnemyShip.h"
#import "XRuser.h"
#import "XTroyer.h"
#import "XStar.h"
#import "EnemyShipBullet.h"

typedef enum EnemyMovement {EnemyMovementNormal,
    EnemyMovementRightArc,EnemyMovementLeftArc} EnemyMovement;

typedef enum EnemyType{EnemyTypeXRuser,EnemyTypeXTroyer,
    EnemyTypeXStar} EnemyType;

@interface EnemyFactory : NSObject
{
}

+ (EnemyFactory *)sharedFactory;
+ (EnemyShip *)CreateEnemies:(EnemyType) enemyType AndTheMovement:(EnemyMovement)movement;
+ (NSArray *)CreateEnemies:(EnemyType) enemyType AndTheMovement:(EnemyMovement)movement AndTheirPositions:(NSArray *) myCGPointArray;
+ (NSArray *)CreateEnemies:(EnemyType) enemyType AndTheMovement:(EnemyMovement)movement AndTheirAmount:(int) amount;
+ (EnemyShip *)CreateRandomEnemy;
+ (CGPoint) getPossibleCGPoint:(EnemyMovement)movement;



@end