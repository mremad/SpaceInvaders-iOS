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

typedef enum EnemyMovement {MovementNormal,
    MovementArc} EnemyMovement;

typedef enum EnemyType{EnemyTypeXRuser,EnemyTypeXTroyer,
    EnemyTypeXStar} EnemyType;

@interface EnemyFactory : NSObject
{
}

+ (EnemyFactory *)sharedFactory;
+ (NSArray *)CreateEnemies:(EnemyType) enemyType AndTheMovement:(EnemyMovement)movement AndTheirPositions:(NSArray *) myCGPointArray;
+ (EnemyShip *)CreateRandomEnemy;



@end