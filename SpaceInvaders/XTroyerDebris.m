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

+ (SKTexture *)createTexture {
    
    static SKTexture *texture = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        int randDebris = (arc4random()%2) +1;
        NSString* debrisImage = [NSString stringWithFormat:@"debrisRed_%d",randDebris];
        texture = [SKTexture textureWithImageNamed:debrisImage]; //TODO TEAM RAVI
        texture.filteringMode = SKTextureFilteringNearest;
        
    });
    
    return texture;
    
}

@end
