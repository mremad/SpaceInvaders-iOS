//
//  MyScene.m
//  SpaceInvaders
//
//  Created by M on 11/26/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "MyScene.h"
#import "Upgrade.h"

@implementation MyScene
{
    //Game Objects
    SpaceShip *_spaceShip;
    float _score;
    NSArray  *upgrades;
    BOOL automaticShooting;
    SKLabelNode *_scoreNode;
}
-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        //TODO: Add a nice Background
        /*
        SKSpriteNode* bg = [SKSpriteNode spriteNodeWithImageNamed:@"bg.jpg"];
        bg.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bg];
         */
        
        //Added Background Particle Node
         [self setupBackground];

        
 
        
        //there is no gravity in space...
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        /* Setup your scene here */
        automaticShooting=YES;
        self.backgroundColor = [SKColor blackColor];
        _gameRunning=YES;
        _layerEnemiesNode=[SKNode new];
        [self addChild:_layerEnemiesNode];
        _layerPlayerNode = [SKNode new];
        [self addChild:_layerPlayerNode];
        _layerSpaceShipBulletsNode = [SKNode new];
        [self addChild:_layerSpaceShipBulletsNode];
       
        _spaceShip = [[SpaceShip alloc] initWithPosition:CGPointMake((self.size.width / 2), 120)];
        //spaceShip.position here will return the correct position;
        [_layerPlayerNode addChild:_spaceShip];
        
        [self levelX];
        //[self level2];

     
        upgrades = [NSArray arrayWithObjects:[NSNumber numberWithInt:UpgradeAutomaticShooting], nil];
        [self evaluateUpdates];
        [self setupHUD];
    }
    return self;
}

-(void)setupBackground{
    
    SKEmitterNode* starBg = [MyScene newStarParticles];
    starBg.position = CGPointMake(self.size.width/2, self.size.height/2);
    starBg.speed = -5;
    [self addChild:starBg];
    
    _starLayerNode = [SKNode new];
    
    NSString *largeStar = @"star_1_large.png";
    NSString *smallStar = @"star_2_small.png";
    

    SKEmitterNode *star1 = [self starLayer:1 scale:0.2 speed:16 textureName:smallStar];
    
    SKEmitterNode *star2 = [self starLayer:1 scale:0.4 speed:20 textureName:largeStar];
    
    [_starLayerNode addChild:star1];
    [_starLayerNode addChild:star2];
    [self addChild:_starLayerNode];
    
    _layerFirstBackground = [SKNode new];
    _layerSecondBackground = [SKNode new];
    [self addChild:_layerFirstBackground];
    [self addChild:_layerSecondBackground];
    _layerFirstBackground.alpha = 0.4;
    _layerSecondBackground.alpha = 0.4;
    [self createSecondBackground];
    [self createFirstBackground];
    

}

+(SKEmitterNode *) newStarParticles
{
    NSString *starPath = [[NSBundle mainBundle] pathForResource:@"BokehParticles" ofType:@"sks"];
    SKEmitterNode *star = [NSKeyedUnarchiver unarchiveObjectWithFile:starPath];
    return star;
}
-(SKEmitterNode *)starLayer:(float)birthRate
                      scale:(float)scale
                      speed:(float)speed
                textureName:(NSString *)textureName
{
    SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
    
    SKEmitterNode *starNode = [SKEmitterNode new];
    starNode.particleTexture = texture;
    starNode.particleBirthRate = birthRate;
    starNode.particleScale = scale;
    starNode.particleLifetime = self.frame.size.height/5;
    starNode.speed = speed;
    starNode.particleSpeedRange = 10;
    starNode.particleColor = [SKColor darkGrayColor];
    starNode.particleColorBlendFactor = 0;
    starNode.position = CGPointMake((CGRectGetMidX(self.frame)), CGRectGetMaxY(self.frame));
    
    starNode.particlePositionRange = CGVectorMake(CGRectGetMaxX(self.frame), 0);
    
    [starNode advanceSimulationTime:starNode.particleLifetime];
    return starNode;
    
}

-(void)createFirstBackground
{
    SKSpriteNode* planet1 = [SKSpriteNode spriteNodeWithImageNamed:@"planetStripe_1.png"];
    planet1.size = CGSizeMake(100, 100);
    planet1.position = CGPointMake(100, 100);
    planet1.speed = -16;
    SKSpriteNode* planet2 = [SKSpriteNode spriteNodeWithImageNamed:@"planetStripe_2.png"];
    planet2.size = CGSizeMake(50, 50);
    planet2.position = CGPointMake(200, 500);
    planet2.speed = -15;
    [_layerFirstBackground addChild:planet1];
    [_layerFirstBackground addChild:planet2];
    _layerFirstBackground.position = CGPointMake(0, 0);
}

-(void)createSecondBackground
{
    SKSpriteNode* planet1 = [SKSpriteNode spriteNodeWithImageNamed:@"planetStripe_1.png"];
    planet1.size = CGSizeMake(100, 100);
    planet1.position = CGPointMake(100, 200);
    planet1.speed = -14;
    SKSpriteNode* planet2 = [SKSpriteNode spriteNodeWithImageNamed:@"planetStripe_2.png"];
    planet2.size = CGSizeMake(75, 75);
    planet2.position = CGPointMake(200, 400);
    planet2.speed = -12;
    [_layerSecondBackground addChild:planet1];
    [_layerSecondBackground addChild:planet2];
    _layerSecondBackground.position = CGPointMake(0, self.size.height);

}

-(void) level1
{
    //Setup the enemies from top
    SKAction *spawnEnemiesAction1 = [SKAction performSelector:@selector(addXRuserEnemy) onTarget:self];
    SKAction *waitAction = [SKAction waitForDuration:1 withRange:3];
    SKAction *firstWave = [SKAction repeatAction:[SKAction sequence:@[spawnEnemiesAction1, waitAction]] count:20];
    
    SKAction *waitActionBetweenWaves = [SKAction waitForDuration:2];
    
    //Setup up the enemies from left
    SKAction *spawnEnemiesAction2 = [SKAction performSelector:@selector(addXTroyerEnemy) onTarget:self];
    SKAction *secondWave =[SKAction repeatAction:[SKAction sequence:@[spawnEnemiesAction2, waitAction]] count:15];
    
    //Setup the enemies from top and left
    SKAction *thirdWave =[SKAction repeatAction:[SKAction sequence:@[spawnEnemiesAction1, waitAction,spawnEnemiesAction2, waitAction]] count:10];
    
    //Setup up the enemies from the right and the left
    SKAction *spawnEnemiesAction3 = [SKAction performSelector:@selector(addXRuserEnemyRightArc) onTarget:self];
    SKAction *fourthWave =[SKAction repeatAction:[SKAction sequence:@[spawnEnemiesAction2, waitAction,spawnEnemiesAction3, waitAction]] count:8];
    
    
    [self runAction:[SKAction sequence:@[firstWave ,waitActionBetweenWaves, secondWave,waitActionBetweenWaves, thirdWave ,waitActionBetweenWaves,fourthWave]]];
}

-(void) level2
{
    //Setup the enemies from top
    SKAction *spawnEnemiesAction1 = [SKAction performSelector:@selector(addXTroyerEnemy) onTarget:self];
    SKAction *waitAction = [SKAction waitForDuration:1 withRange:3];
    SKAction *firstWave = [SKAction repeatAction:[SKAction sequence:@[spawnEnemiesAction1, waitAction]] count:20];
    
    SKAction *waitActionBetweenWaves = [SKAction waitForDuration:2];
    
    //Setup up the enemies from left
    SKAction *spawnEnemiesAction2 = [SKAction performSelector:@selector(addXStarEnemy) onTarget:self];
    SKAction *secondWave =[SKAction repeatAction:[SKAction sequence:@[spawnEnemiesAction2, waitAction]] count:15];
    
    //Setup the enemies from top and left
    SKAction *thirdWave =[SKAction repeatAction:[SKAction sequence:@[spawnEnemiesAction1, waitAction,spawnEnemiesAction2, waitAction]] count:10];
    
    //Setup up the enemies from the right and the left
    SKAction *spawnEnemiesAction3 = [SKAction performSelector:@selector(addXTroyerEnemyRightArc) onTarget:self];
    SKAction *fourthWave =[SKAction repeatAction:[SKAction sequence:@[spawnEnemiesAction2, waitAction,spawnEnemiesAction3, waitAction]] count:8];
    
    
    [self runAction:[SKAction sequence:@[firstWave ,waitActionBetweenWaves, secondWave,waitActionBetweenWaves, thirdWave ,waitActionBetweenWaves,fourthWave]]];
}

-(void) levelX
{
    //Setup the enemies from top
    SKAction *spawnEnemiesAction1 = [SKAction performSelector:@selector(addXRuserEnemy) onTarget:self];
    SKAction *waitAction = [SKAction waitForDuration:1 withRange:3];
  
    
    //Setup up the enemies from left
    SKAction *spawnEnemiesAction2 = [SKAction performSelector:@selector(addXTroyerEnemyRightArc) onTarget:self];
    SKAction *spawnEnemiesAction5 = [SKAction performSelector:@selector(addXTroyerEnemyLeftArc) onTarget:self];
    
    //Setup the enemies from top and left
    SKAction *thirdWave =[SKAction repeatAction:[SKAction sequence:@[spawnEnemiesAction1, waitAction,spawnEnemiesAction2, waitAction,spawnEnemiesAction5,waitAction]] count:30];
    
    
   
    
    [self runAction:[SKAction sequence:@[thirdWave]]];
}

-(void) evaluateUpdates
{
    //do something with upgrades
}

-(void) addRandomEnemy
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateRandomEnemy]];
}

-(void) addXRuserEnemy
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXRuser AndTheMovement:EnemyMovementNormal]];
}

-(void) addXRuserEnemyLeftArc
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXRuser AndTheMovement:EnemyMovementLeftArc]];
}

-(void) addXRuserEnemyRightArc
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXRuser AndTheMovement:EnemyMovementRightArc]];
}

-(void) addXTroyerEnemy
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXTroyer AndTheMovement:EnemyMovementNormal]];
}



-(void) addXTroyerEnemyRightArc
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXTroyer AndTheMovement:EnemyMovementRightArc]];
}

-(void) addXTroyerEnemyLeftArc
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXTroyer AndTheMovement:EnemyMovementLeftArc]];
}

-(void) addXStarEnemy
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXStar AndTheMovement:EnemyMovementNormal]];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint p=_spaceShip.position;
    p.y+=5;

    SpaceShipBullet *bullet = [[SpaceShipBullet alloc]initWithPosition:p];
    [bullet runAction:[self normalBulletAction]];
    [_layerSpaceShipBulletsNode addChild:bullet];
    
    
    
    
}


//Uncomment to test while moving ship

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event touchesForView:self.view] anyObject];
    
    CGPoint location = [touch locationInNode:self];
    _spaceShip.position = location;
}


-(SKAction *) normalBulletAction
{
    //Move the bullet down the screen and remove it when it is of screen
    SKAction *moveAction = [SKAction moveToY:1000 duration:3];//TODO set appropiate numbers (duration and moveTo handle ultamately the speed.. .. used for the upgrade for ex)
    SKAction *removeBullet= [SKAction removeFromParent];
    SKAction *bulletSequence = [SKAction sequence:@[moveAction, removeBullet]];
    return bulletSequence;
}


- (void)didBeginContact:(SKPhysicsContact *)contact {
    
    if(_gameRunning) {
        
        SKNode *contactNode1 = contact.bodyA.node;
        SKNode *contactNode2 = contact.bodyB.node;
        if([contactNode1 isKindOfClass:[GameObject class]]) {
            [(GameObject *)contactNode1 collidedWith:contact.bodyB contact:contact];
        }
        if([contactNode2 isKindOfClass:[GameObject class]]) {
            [(GameObject *)contactNode2 collidedWith:contact.bodyA contact:contact];
        }
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact
{    
    
}

- (void)increaseScoreBy:(float)amount
{
    _score += amount;
    _scoreNode.text = [NSString stringWithFormat:@"Score:%1.0f", _score];
}



-(void)update:(CFTimeInterval)currentTime {
 /* Called before each frame is rendered */
    
    _layerSecondBackground.position = CGPointMake(_layerSecondBackground.position.x, _layerSecondBackground.position.y-1);
    _layerFirstBackground.position = CGPointMake(_layerSecondBackground.position.x, _layerFirstBackground.position.y-1);
    
    if(_layerSecondBackground.position.y <= -1*self.size.height)
        _layerSecondBackground.position = CGPointMake(0, self.size.height);
    
    if(_layerFirstBackground.position.y <= -1*self.size.height)
        _layerFirstBackground.position = CGPointMake(0, self.size.height);
}

- (void)setupHUD {
    //Heads Up Display
    
    //Add HUD
    _layerHudNode = [SKNode new];
    
    //setup HUD basics
    int hudHeight = 25;
    CGSize bgSize = CGSizeMake(self.size.width, hudHeight);
    SKColor *bgColor = [SKColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.30];
    SKSpriteNode *hudBackground = [SKSpriteNode spriteNodeWithColor:bgColor size:bgSize];
    
    hudBackground.position = CGPointMake(0, self.size.height - hudHeight);
    hudBackground.anchorPoint = CGPointZero;
    [_layerHudNode addChild:hudBackground];
    
    _scoreNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _scoreNode.fontSize = 12.0;
    _scoreNode.text = @"Score:0";
    _scoreNode.name = @"scoreNode";
    _scoreNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _scoreNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    
    _scoreNode.position = CGPointMake(6, self.size.height - _scoreNode.frame.size.height -2);

    [_layerHudNode addChild:_scoreNode];
    [self addChild:_layerHudNode];
}


@end
