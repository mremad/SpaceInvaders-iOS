//
//  XTroyerDebris.m
//  SpaceInvaders
//
//  Created by Mohamed Emad on 12/1/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "XTroyerDebris.h"

@implementation XTroyerDebris

- (id)initWithPosition:(CGPoint)position withContact:(SKPhysicsContact *)contact {
    
    if(self = [super initWithPosition:position withContact:contact]) {
        
       
        

    }
    
    return self;
}

- (SKTexture*)createDebrisTexture
{
    SKTexture *texture = nil;
    int randDebris = (arc4random()%2) +1;
    NSLog(@"Rand debris:%d",randDebris);
    NSString* debrisImage = [NSString stringWithFormat:@"debrisPurple_%d",randDebris];
    texture = [SKTexture textureWithImageNamed:debrisImage]; //TODO TEAM RAVI
    texture.filteringMode = SKTextureFilteringNearest;
    
    
    return texture;
    
}

+ (SKTexture *)createTexture {
    
    return nil;
}

@end
