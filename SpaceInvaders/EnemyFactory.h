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
#import "XBooster.h"
#import "XCorner.h"
#import "XDollar.h"
#import "EnemyShipBullet.h"
#import "define.h"

@interface EnemyFactory : NSObject
{
}

+ (EnemyShip *)CreateEnemies:(EnemyType) enemyType AndTheMovement:(EnemyMovement)movement;
+ (NSArray *)CreateEnemies:(EnemyType) enemyType AndTheMovement:(EnemyMovement)movement AndTheirPositions:(NSArray *) myCGPointArray;
+ (NSArray *)CreateEnemies:(EnemyType) enemyType AndTheMovement:(EnemyMovement)movement AndTheirAmount:(int) amount;
+ (EnemyShip *)CreateRandomEnemy;
+ (CGPoint) getPossibleCGPoint:(EnemyMovement)movement;
@end