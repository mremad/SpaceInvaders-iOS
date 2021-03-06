//
//  SpaceShip.m
//  SpaceInvaders
//
//  Created by M on 11/27/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "SpaceShip.h"
#import "MyScene.h"

@implementation SpaceShip

- (id)initWithPosition:(CGPoint)position {
    
    if(self = [super initWithPosition:position]) {
        
        //Name the alien and reduce it's size to 70%--it looks about right.
        self.name = @"SpaceShip";
        [self setScale:0.2f];
        [self configureCollisionBody];
        
        //Add fuel ignition particles
        SKEmitterNode* leftFuel = [GameObject newFuelEmitter];
        leftFuel.position = CGPointMake(self.size.width/2-70,self.size.height/2 - 65);
        leftFuel.particleScale = 0.7;
        [self addChild:leftFuel];
        
        SKEmitterNode* rightFuel = [GameObject newFuelEmitter];
        rightFuel.position = CGPointMake(self.size.width/2+30,self.size.height/2 - 65);
        rightFuel.particleScale = 0.7;
        [self addChild:rightFuel];
        
       
        [self setMaxHealth:10]; //TODO put back to 3
        [self setHealth:10];
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
    ((SKEffectNode*)self.parent).filter = nil;
    [((SKEffectNode*)self.parent) removeActionForKey:@"BlinkingAction"];
}



- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact *)contact
{   //if the SpaceShip collided with anything destory it
    
    [self setHealth:([self getHealth]-1)];
    SKEmitterNode* fireParticles = [GameObject newExplosionEmitter];
    fireParticles.position = contact.contactPoint;
    fireParticles.particleScale = 0.001;
    fireParticles.numParticlesToEmit = 50;
    [self.parent addChild:fireParticles];
    
    if([self getHealth]==0)
    {
        //Updating High Scores when Spaceship destroyed and letting Game View Controller know
        [(MyScene *)self.scene spaceShipIsDestroyed];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GameComplete" object:nil];
        [self removeNodeWithEffectsAtContactPoint:contact];
    }
    else if([self getHealth] == 2)
    {
        [self IndicateWarning];
    }
}


-(void) IndicateWarning
{
    

        CIFilter* filter = [CIFilter filterWithName:@"CIColorInvert"];
        ((SKEffectNode*)self.parent).filter = filter;
        ((SKEffectNode*)self.parent).shouldEnableEffects = NO;
        SKAction* blinkAction = [SKAction runBlock:^{((SKEffectNode*)self.parent).shouldEnableEffects = !((SKEffectNode*)self.parent).shouldEnableEffects;}];
        float duration = [self getHealth] *0.1;
        SKAction* waitAction = [SKAction waitForDuration:duration];
        
        SKAction* sequence = [SKAction repeatActionForever: [SKAction sequence:[NSArray arrayWithObjects:blinkAction,waitAction, nil]]];
        
        [self runAction:sequence withKey:@"BlinkingAction"];
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
        
        texture = [SKTexture textureWithImageNamed:@"mainship.png"];
        texture.filteringMode = SKTextureFilteringNearest;
        
    });
    
    return texture;
    
}
     
@end

