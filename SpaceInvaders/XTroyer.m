//
//  Xtroyer.m
//  SpaceInvaders
//
//  Created by M on 11/27/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "XTroyer.h"
#import "MyScene.h"

@implementation XTroyer
- (id)initWithPosition:(CGPoint)position {
    
    if(self = [super initWithPosition:position]) {
        
        //Name the alien and reduce it's size to 70%--it looks about right.
        self.name = @"EnemyXTroyer";
        [self setScale:0.2f]; //TODO TEAM RAVI
        
        SKEmitterNode* fuelLeft = [GameObject newFuelEmitter];
        fuelLeft.emissionAngle = 1.57;
        fuelLeft.position = CGPointMake(self.size.width/2,self.size.height);
        [self addChild:fuelLeft];
        
        SKEmitterNode* fuelRight = [GameObject newFuelEmitter];
        fuelRight.emissionAngle = 1.57;
        fuelRight.position = CGPointMake(self.size.width/2 - 40,self.size.height);
        [self addChild:fuelRight];

        
        [self configureCollisionBody];
    }
    
    return self;
}

-(void) removeNodeWithEffectsAtContactPoint:(SKPhysicsContact*)contact
{
    [self.parent addChild:[[XTroyerDebris alloc] initWithPosition:self.position withContact:contact]];
    [super removeNodeWithEffectsAtContactPoint:contact];
}

- (float)increaseScoreAmount
{
    return 20;
}


- (void)configureCollisionBody {
    
    /*
     This alien will collide with the Spaceship, but will not move itself--it will push the Spaceship out of the way.  This is accomplished by setting the collisionBitMask to 0, but setting the contactTestBitMask to the Spaceship.
     */
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width-10, self.frame.size.height-20)];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = CollisionTypeEnemyXTroyer;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionTypeSpaceShipBullet|CollisionTypeSpaceShip;
}

+ (SKTexture *)createTexture {
    
    static SKTexture *texture = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        texture = [SKTexture textureWithImageNamed:@"shipPurple.png"]; //TODO TEAM RAVI
        texture.filteringMode = SKTextureFilteringNearest;
        
    });
    
    return texture;
    
}
@end