//
//  GameObject.m
//  SpaceInvaders
//
//  Created by M on 11/27/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject {
    float _health;
}

- (instancetype) initWithPosition:(CGPoint)position {
    
    if(self = [super init]) {
        
        //All game play objects will instanciate with at lease these basic properties.
        _heading = CGPointZero;
        self.position = position;
        
        self.texture = [[self class] createTexture];
        self.size = self.texture.size;
    }
    
    return self;
}

- (void)setHealth:(float)health {
    if(health > self.maxHealth) {
        _health = self.maxHealth;
    } else {
        _health = health;
    }
}

-(void) removeNodeWhileShowingSomeGraphicsOfTheDestruction
{
    SKEmitterNode* explosion = [GameObject newExplosionEmitter];
    
    explosion.numParticlesToEmit = 125;
    explosion.position = CGPointMake(self.position.x, self.position.y);
    
    [self.parent addChild:explosion];
    
    [self removeFromParent];
    
}

+(SKEmitterNode*)newFuelEmitter
{
    NSString *fuelPath = [[NSBundle mainBundle] pathForResource:@"FuelBurningParticles" ofType:@"sks"];
    SKEmitterNode *fuel = [NSKeyedUnarchiver unarchiveObjectWithFile:fuelPath];
    return fuel;
}



+(SKEmitterNode *) newExplosionEmitter
{
    NSString *explosionPath = [[NSBundle mainBundle] pathForResource:@"FireParticles" ofType:@"sks"];
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
    return explosion;
}

+(SKEmitterNode *) newBulletEmitter
{
    NSString *bulletPath = [[NSBundle mainBundle] pathForResource:@"BulletParticle" ofType:@"sks"];
    SKEmitterNode *bullet = [NSKeyedUnarchiver unarchiveObjectWithFile:bulletPath];
    return bullet;
}

//to be overridden
- (void)update:(CFTimeInterval)timeSpan {}
- (void)configureCollisionBody {}
- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact *)contact {}
+ (SKTexture *)createTexture {return nil;}
@end
