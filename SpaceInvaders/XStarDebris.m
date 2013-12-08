//
//  XStarDebris.m
//  SpaceInvaders
//
//  Created by M on 12/8/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "XStarDebris.h"

@implementation XStarDebris
- (id)initWithPosition:(CGPoint)position withContact:(SKPhysicsContact *)contact {
    
    if(self = [super initWithPosition:position withContact:contact]) {
        
    }
    
    return self;
}


- (SKTexture*)createDebrisTexture
{
    static SKTexture *texture = nil;
    
    int randDebris = (arc4random()%2) +1;
    NSString* debrisImage = [NSString stringWithFormat:@"xstarDebris_%d",randDebris];
    texture = [SKTexture textureWithImageNamed:debrisImage]; //TODO TEAM RAVI
    texture.filteringMode = SKTextureFilteringNearest;
    
    return texture;
    
}

+ (SKTexture *)createTexture {
    
    return nil;
    
}

@end
