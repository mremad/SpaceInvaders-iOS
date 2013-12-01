//
//  XTroyerDebris.h
//  SpaceInvaders
//
//  Created by Mohamed Emad on 11/30/13.
//  Copyright (c) 2013 M. All rights reserved.
//
#import "GameObject.h"

@interface EnemyShipDebris : GameObject

- (id)initWithPosition:(CGPoint)position withContact:(SKPhysicsContact*)contact;

@end

