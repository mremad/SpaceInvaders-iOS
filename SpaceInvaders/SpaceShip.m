//
//  SpaceShip.m
//  SpaceInvaders
//
//  Created by M on 11/27/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "SpaceShip.h"

@implementation SpaceShip

- (id)initWithPosition:(CGPoint)position {
    
    if(self = [super initWithPosition:position]) {
        
        //Name the alien and reduce it's size to 70%--it looks about right.
        self.name = @"SpaceShip";
        [self setScale:0.2f];
        [self configureCollisionBody];
        
        //Add fuel ignition particles
        SKEmitterNode* leftFuel = [GameObject newFuelEmitter];
        leftFuel.position = CGPointMake(self.size.width/2 - 70,self.size.height/2 - 60);
        [self addChild:leftFuel];
        
        SKEmitterNode* rightFuel = [GameObject newFuelEmitter];
        rightFuel.position = CGPointMake(self.size.width/2 + 25,self.size.height/2 - 60);
        [self addChild:rightFuel];
        [self setMaxHealth:3000]; //TODO put back to 3
        [self setHealth:3000];
    }
    
    return self;
}

-(void)setHealth :(float) myHealth
{
    [super setHealth:myHealth];
}

-(float)getHealth
{
    return [super health];
}

-(void)restoreMaxHealth
{
    [super setHealth:[super maxHealth]];
    [self removeWarningIndication];
}

-(void)removeWarningIndication
{
    //TODO EMAD
}



- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact *)contact
{   //if the SpaceShip collided with anything destory it
    
    [self setHealth:([self getHealth]-1)];
    if([self getHealth]==0)
    {
        [self removeNodeWithEffectsAtContactPoint:contact];
    }
    else
    {
        [self IndicateWarning];
    }
}


-(void) IndicateWarning
{
    
    static BOOL warnedForLowHealth = NO;
  
    if(!warnedForLowHealth)
    {
        CIFilter* filter = [CIFilter filterWithName:@"CIColorInvert"];
        ((SKEffectNode*)self.parent).filter = filter;
        ((SKEffectNode*)self.parent).shouldEnableEffects = NO;
        SKAction* blinkAction = [SKAction runBlock:^{((SKEffectNode*)self.parent).shouldEnableEffects = !((SKEffectNode*)self.parent).shouldEnableEffects;}];
        float duration = [self getHealth] *0.1;
        SKAction* waitAction = [SKAction waitForDuration:duration];
        
        SKAction* sequence = [SKAction repeatActionForever: [SKAction sequence:[NSArray arrayWithObjects:blinkAction,waitAction, nil]]];
        
        [self runAction:sequence];
        warnedForLowHealth = YES;
    }
    
}


- (void)configureCollisionBody {
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width-10, self.frame.size.height-5)];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = CollisionTypeSpaceShip;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionTypeEnemyXRuser;
}



+ (SKTexture *)createTexture {
    
    static SKTexture *texture = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        texture = [SKTexture textureWithImageNamed:@"WhiteSpaceShip.png"];
        texture.filteringMode = SKTextureFilteringNearest;
        
    });
    
    return texture;
    
}
@end

