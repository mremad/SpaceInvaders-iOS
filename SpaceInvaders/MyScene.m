//
//  MyScene.m
//  SpaceInvaders
//
//  Created by M on 11/26/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene
{
    //Game Objects
    SpaceShip *_spaceShip;
    
    float _score;

}
-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
        
        //Setup the monkey
        _layerPlayerNode = [SKNode new];
        _spaceShip = [[SpaceShip alloc] initWithPosition:CGPointMake((self.size.width / 2), 120)];
        [_layerPlayerNode addChild:_spaceShip];
        //[_monkey startFlyAnimation];
        
        [self addChild:_layerPlayerNode];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
