//
//  EnemyShip.m
//  SpaceInvaders
//
//  Created by M on 11/27/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "EnemyShip.h"

@implementation EnemyShip
- (id)initWithPosition:(CGPoint)position {
    
    if(self = [super initWithPosition:position]) {
        
        //Name the asteroid and reduce it's size to 70%--it looks about right.
        self.name = @"spaceShipBullet";
        [self setScale:0.02f];
        [self configureCollisionBody];
    }
    
    return self;
}



- (void)configureCollisionBody
{
    [self doesNotRecognizeSelector:_cmd]; // without overriding this method, this method is not usable(As If abstract)
}

+ (SKTexture *)createTexture
{
   [self doesNotRecognizeSelector:_cmd]; // without overriding this method, this method is not usable(As If abstract)
    return nil;
    
}
@end
