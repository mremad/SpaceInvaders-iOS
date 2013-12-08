//
//  XBoosterDebris.h
//  SpaceInvaders
//
//  Created by M on 12/8/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "EnemyShipDebris.h"

@interface XBoosterDebris : EnemyShipDebris
- (id)initWithPosition:(CGPoint)position withContact:(SKPhysicsContact *)contact;
@end
