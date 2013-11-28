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

@interface EnemyFactory : NSObject
{
}

+ (EnemyFactory *)sharedFactory;
+ (EnemyShip *)CreateEnemyXRuser;
+ (EnemyShip *)CreateEnemyXTroyer;
+ (EnemyShip *)CreateEnemyXStar;
+ (EnemyShip *)CreateSingleRandomEnemy;


@end