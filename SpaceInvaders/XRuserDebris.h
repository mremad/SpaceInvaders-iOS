//
//  XRuserDebris.h
//  SpaceInvaders
//
//  Created by Mohamed Emad on 12/1/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "EnemyShipDebris.h"

@interface XRuserDebris : EnemyShipDebris

- (id)initWithPosition:(CGPoint)position withContact:(SKPhysicsContact *)contact;

@end
