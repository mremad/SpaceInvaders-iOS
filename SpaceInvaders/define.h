//
//  define.h
//  SpaceInvaders
//
//  Created by M on 12/4/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum EnemyMovement {EnemyMovementNormal,
    EnemyMovementRightArc,EnemyMovementLeftArc} EnemyMovement;

typedef enum EnemyType{EnemyTypeXBooster,EnemyTypeXCorner,EnemyTypeXDollar,EnemyTypeXRuser,EnemyTypeXTroyer,
    EnemyTypeXStar} EnemyType;


typedef NS_OPTIONS(uint32_t, CollisionType) {
    CollisionTypeSpaceShip      = 1 << 0,
    CollisionTypeSpaceShipBullet   = 1 << 1,
    CollisionTypeEnemyXRuser     = 1 << 2,
    CollisionTypeEnemyXTroyer      = 1 << 3,
    CollisionTypeEnemyXStar      = 1 << 4,
    CollisionTypeEnemyBullet      = 1 << 5,
    CollisionTypeDebrisBullet = 1 << 6,
};
@interface define : NSObject

@end
