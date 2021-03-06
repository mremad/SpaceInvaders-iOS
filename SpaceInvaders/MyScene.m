//
//  MyScene.m
//  SpaceInvaders
//
//  Created by M on 11/26/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "UpgradeCenter.h"
#import "MyScene.h"

#import "UpgradeViewController.h"
#import "AppDelegate.h"

@implementation MyScene
{
    //Upgrade Center
    UpgradeCenter* upgradeCenter;
    
    //Game Objects
    SpaceShip *_spaceShip;
    float _score;
    BOOL automaticShooting;
    SKLabelNode *_scoreNode;
    SKLabelNode *_upgradeBalanceNode;
    SKLabelNode *_levelNode;
    int level;
    int amountEnemiesInTheCurrentLevel;
    int amountDeadEnemiesInTheCurrentLevel;
    NSMutableArray *levelNSActions;
    float gameDifficulty;
}

- (void)increaseScoreBy:(float)amount
{
    upgradeCenter.playerBalance += amount/10.0;
    _score += amount;
    _scoreNode.text = [NSString stringWithFormat:@"Score:%1.0f", _score];
    _upgradeBalanceNode.text = [NSString stringWithFormat:@"Coins:%d",upgradeCenter.playerBalance];
    _levelNode.text =[NSString stringWithFormat:@"Level %d",level+1];
}

-(void)setUpgradeCenter:(id)upCenter
{
    upgradeCenter = (UpgradeCenter*)upCenter;
    upgradeCenter.scene = self;
    [upgradeCenter purchaseUpgrade:UpgradeDestroyAllEnemys];
    [upgradeCenter purchaseUpgrade:UpgradeSideBullets];
    [upgradeCenter purchaseUpgrade:UpgradeFreeze];
}

#pragma mark - Initilization
-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        
        //Added Background Particle Node
        [self setupBackground];
        
        

        storedScores = [self readFromPlist:@"Scores.plist"];
        if (storedScores == nil) {
            storedScores = [[NSMutableArray alloc] initWithCapacity:10];
            for (int i=0; i < 10; i++) {
                storedScores[i] = [NSNumber numberWithInt:0];
            }
        }
        
 
        
        //there is no gravity in space...
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        /* Setup your scene here */
        automaticShooting=YES;
        self.backgroundColor = [SKColor blackColor];
        _gameRunning=YES;
        _layerEnemiesNode=[SKNode new];
        [self addChild:_layerEnemiesNode];
        _layerPlayerNode = [SKEffectNode new];
        [self addChild:_layerPlayerNode];
        _layerSpaceShipBulletsNode = [SKNode new];
        [self addChild:_layerSpaceShipBulletsNode];
       
        _spaceShip = [[SpaceShip alloc] initWithPosition:CGPointMake((self.size.width / 2), 120)];
        //spaceShip.position here will return the correct position;
        [_layerPlayerNode addChild:_spaceShip];
        
        [self HandleLevels];
     
        [self setupHUD];
        [self setupUpgradeHUD];
    }
    return self;
}

-(void)setupUpgradeHUD
{
    _layerUpgradeNode = [SKNode new];
    
    int HUDWidth = self.size.width;
    int HUDHeight = 35;
    
    SKSpriteNode *hudBackground = [SKSpriteNode spriteNodeWithImageNamed:@"Upgrade-HUD-bg.jpg"];
    hudBackground.position = CGPointMake(0, 0);
    hudBackground.anchorPoint = CGPointZero;
    hudBackground.size = CGSizeMake(HUDWidth, HUDHeight);
    
    SKSpriteNode *freezeSprite = [SKSpriteNode spriteNodeWithImageNamed:@"freeze-sprite.png"];
    freezeSprite.position = CGPointMake(4, 7);
    freezeSprite.anchorPoint = CGPointZero;
    freezeSprite.size = CGSizeMake(65/2, 45/2);
    freezeSprite.alpha = 0.8;
    
    SKSpriteNode *automaticSprite = [SKSpriteNode spriteNodeWithImageNamed:@"automatic-sprite.png"];
    automaticSprite.position = CGPointMake(4+4+4+(65/2), 7);
    automaticSprite.anchorPoint = CGPointZero;
    automaticSprite.size = CGSizeMake(65/2, 45/2);
    automaticSprite.alpha = 0.8;
    
    SKSpriteNode *sideBulletsSprite = [SKSpriteNode spriteNodeWithImageNamed:@"sidebullets-sprite.png"];
    sideBulletsSprite.position = CGPointMake(4+2*4+2*4+(2*65/2), 7);
    sideBulletsSprite.anchorPoint = CGPointZero;
    sideBulletsSprite.size = CGSizeMake(65/2, 45/2);
    sideBulletsSprite.alpha = 0.8;
    
    SKSpriteNode *explodeAllSprite = [SKSpriteNode spriteNodeWithImageNamed:@"explodeall-sprite.png"];
    explodeAllSprite.position = CGPointMake(4+3*4+3*4+(3*65/2), 7);
    explodeAllSprite.anchorPoint = CGPointZero;
    explodeAllSprite.size = CGSizeMake(65/2, 45/2);
    explodeAllSprite.alpha = 0.8;
    
    //_layerUpgradeNode.userInteractionEnabled = YES;
    freezeSprite.name = @"Freeze";
    //freezeSprite.userInteractionEnabled = YES;
    sideBulletsSprite.name=@"SideBullets";
    //sideBulletsSprite.userInteractionEnabled = YES;
    automaticSprite.name = @"AutomaticShooting";
    //automaticSprite.userInteractionEnabled = YES;
    explodeAllSprite.name = @"ExplodeAll";
    //explodeAllSprite.userInteractionEnabled = YES;
    
    [_layerUpgradeNode addChild:hudBackground];
    [_layerUpgradeNode addChild:freezeSprite];
    [_layerUpgradeNode addChild:automaticSprite];
    [_layerUpgradeNode addChild:explodeAllSprite];
    [_layerUpgradeNode addChild:sideBulletsSprite];
    
    
    
    [self addChild:_layerUpgradeNode];
}

- (void)setupHUD {
    //Heads Up Display
    
    //Add HUD
    _layerHudNode = [SKNode new];
    
    //setup HUD basics
    int hudHeight = 35;
    CGSize bgSize = CGSizeMake(self.size.width, hudHeight);
    SKColor *bgColor = [SKColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.30];
    SKSpriteNode *hudBackground = [SKSpriteNode spriteNodeWithColor:bgColor size:bgSize];
    
    hudBackground.position = CGPointMake(0, self.size.height - hudHeight);
    hudBackground.anchorPoint = CGPointZero;
    
    [_layerHudNode addChild:hudBackground];
    
    _scoreNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _scoreNode.fontSize = 14.0;
    _scoreNode.text = @"Score:0";
    _scoreNode.name = @"scoreNode";
    _scoreNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _scoreNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    
    _scoreNode.position = CGPointMake(6, self.size.height - _scoreNode.frame.size.height -2);
    
    [_layerHudNode addChild:_scoreNode];
    
    _upgradeBalanceNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _upgradeBalanceNode.fontSize = 14.0;
    _upgradeBalanceNode.text = @"Coins:0";
    _upgradeBalanceNode.name = @"scoreNode";
    _upgradeBalanceNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _upgradeBalanceNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    
    _upgradeBalanceNode.position = CGPointMake(self.size.width - _upgradeBalanceNode.frame.size.width - 6-20, self.size.height - _upgradeBalanceNode.frame.size.height -2);
    
    [_layerHudNode addChild:_upgradeBalanceNode];
    
    _levelNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _levelNode.fontSize = 14.0;
    _levelNode.text = @"Level:1";
    _levelNode.name = @"levelNode";
    _levelNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _levelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    
    _levelNode.position = CGPointMake(self.size.width - _levelNode.frame.size.width - 6-20-70, self.size.height - _levelNode.frame.size.height -2);
    
    [_layerHudNode addChild:_levelNode];
    
    [self addChild:_layerHudNode];
}

-(void)setupBackground{
    
    SKEmitterNode* starBg = [MyScene newStarParticles];
    starBg.position = CGPointMake(self.size.width/2, self.size.height/2);
    //starBg.speed = -5;
    [self addChild:starBg];
    
    _starLayerNode = [SKNode new];
    
    NSString *largeStar = @"star_1_large.png";
    NSString *smallStar = @"star_2_small.png";
    

    SKEmitterNode *star1 = [self starLayer:1 scale:0.1 speed:40 textureName:smallStar];
    
    SKEmitterNode *star2 = [self starLayer:1 scale:0.2 speed:60 textureName:largeStar];
    
    [_starLayerNode addChild:star1];
    [_starLayerNode addChild:star2];
    //[self addChild:_starLayerNode];
    
    _layerFirstBackground = [SKNode new];
    _layerSecondBackground = [SKNode new];
    [self addChild:_layerFirstBackground];
    [self addChild:_layerSecondBackground];
    _layerFirstBackground.alpha = 0.4;
    _layerSecondBackground.alpha = 0.4; 
    [self createSecondBackground];
    [self createFirstBackground];
    

}

#pragma mark - Levels
-(void) HandleLevels
{
    NSArray *allTopSelectorsFromWakestToStrongest=[[NSArray alloc]initWithObjects:@"addXBoosterEnemy", @"addXCornerEnemy", @"addXDollarEnemy", @"addXRuserEnemy", @"addXTroyerEnemy", @"addXStarEnemy", nil];
    NSArray *allLeftArcSelectorsFromWakestToStrongest=[[NSArray alloc]initWithObjects:@"addXBoosterEnemyLeftArc", @"addXCornerEnemyLeftArc", @"addXDollarEnemyLeftArc", @"addXRuserEnemyLeftArc", @"addXTroyerEnemyLeftArc", @"addXStarEnemyLeftArc", nil];
    NSArray *allRightArcSelectorsFromWakestToStrongest=[[NSArray alloc]initWithObjects:@"addXBoosterEnemyRightArc", @"addXCornerEnemyRightArc", @"addXDollarEnemyRightArc", @"addXRuserEnemyRightArc", @"addXTroyerEnemyRightArc", @"addXStarEnemyRightArc", nil];
    NSArray *arrAll = [[NSArray alloc]initWithObjects:allTopSelectorsFromWakestToStrongest,allLeftArcSelectorsFromWakestToStrongest,allRightArcSelectorsFromWakestToStrongest, nil];
    
    SKAction *waitActionBetweenWaves = [SKAction waitForDuration:SECONDS_TO_WAIT_BETWEEN_EACH_WAVE];
    levelNSActions = [[NSMutableArray alloc]init];
    
    int numberOfWaves=[RandomGenerator getNumberOfWaves:level];
    amountEnemiesInTheCurrentLevel=0;
    amountDeadEnemiesInTheCurrentLevel=0;
    for(int i=0;i<numberOfWaves;i++)
    {
        NSMutableArray *waveNSActions=[[NSMutableArray alloc]init];
        
        SEL sel=[RandomGenerator getSelectorGivenSelectorArrays:arrAll AndLevel:level AndWave:i];
        SKAction *spawnEnemiesAction1 = [SKAction performSelector:sel onTarget:self];
        SKAction *waitAction = [SKAction waitForDuration:1 withRange:2];
        [waveNSActions addObject:waitAction];
        [waveNSActions addObject:spawnEnemiesAction1];
        
        
        int amountOfEnemiesInThisWave = [RandomGenerator getCountOfWave:i numberOfWaves:numberOfWaves];
        amountEnemiesInTheCurrentLevel+=amountOfEnemiesInThisWave;
        SKAction *ithWave = [SKAction repeatAction:[SKAction sequence:waveNSActions] count:amountOfEnemiesInThisWave];
        [levelNSActions addObject:ithWave];
        [levelNSActions addObject:waitActionBetweenWaves];
    }
    SKAction *waitActionBetweenLevels = [SKAction waitForDuration:SECONDS_TO_WAIT_BETWEEN_EACH_LEVEL];
    [levelNSActions addObject:waitActionBetweenLevels];
    SKAction *annmationLevelEnded = [SKAction performSelector:@selector(addSomeAnimationSayingThatLevelEnded) onTarget:self];
    [levelNSActions addObject:annmationLevelEnded];

    [_layerEnemiesNode runAction:[SKAction sequence:levelNSActions]];
    //for(SKAction* action in levelNSActions)NSLog(@"%@",action);
}



-(void) spaceShipIsDestroyed //TODO call somewhere
{
    [self storeHighScores:_score];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   
    appDelegate.navJumpToScore=YES;
     OurNavigationController *nvc=(OurNavigationController *) [UIApplication sharedApplication].keyWindow.rootViewController;
    [nvc popToRootViewControllerAnimated:YES];
    
   // [nvc popViewControllerAnimated:NO];
    //[nvc pushViewController:scoreView animated:YES];
    
}

-(void) addSomeAnimationSayingThatLevelEnded
{
    level++;
    [_spaceShip restoreMaxHealth];
    //
    //TODO TEAM
    
    //check if spaceship still alive
    [self HandleLevels];
}


#pragma mark - Background

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
    //starNode.particleSpeedRange = 10;
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




#pragma mark -User Touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    
    if ([node.name isEqualToString:@"Freeze"]) {
        if(upgradeCenter.upgradeList[UpgradeFreeze])
            [upgradeCenter activateUpgrade:UpgradeFreeze];
        
    }
    else if([node.name isEqualToString:@"SideBullets"])
    {
        if(upgradeCenter.upgradeList[UpgradeSideBullets])
            [upgradeCenter activateUpgrade:UpgradeSideBullets];
    }
    else if([node.name isEqualToString:@"AutomaticShooting"])
    {
        if(upgradeCenter.upgradeList[UpgradeAutomaticShooting])
            [upgradeCenter activateUpgrade:UpgradeAutomaticShooting];
    }
    else if([node.name isEqualToString:@"ExplodeAll"])
    {
        if(upgradeCenter.upgradeList[UpgradeDestroyAllEnemys])
            [upgradeCenter activateUpgrade:UpgradeDestroyAllEnemys];
    }
   
    
    
}


-(SKAction *) normalSpaceShipBulletAction
{
    //Move the bullet down the screen and remove it when it is of screen
    SKAction *moveAction = [SKAction moveToY:1000 duration:3];//TODO set appropiate numbers (duration and moveTo handle ultamately the speed.. .. used for the upgrade for ex)
    SKAction *removeBullet= [SKAction removeFromParent];
    SKAction *bulletSequence = [SKAction sequence:@[moveAction, removeBullet]];
    return bulletSequence;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event touchesForView:self.view] anyObject];
    
    CGPoint location = [touch locationInNode:self];
    location.y+=30;
    [_spaceShip runAction:[SKAction moveTo:location duration:0.1]];
}

- (void)moveShipWithxStep:(float)x yStep:(float)y
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if((x>0.01||y>0.01)&&appDelegate.tilting)
    {
        CGPoint position = CGPointMake(_spaceShip.position.x + x*self.size.width, _spaceShip.position.y + y*self.size.height);
        [_spaceShip runAction:[SKAction moveTo:position duration:0.1]];
    }
}

-(void)handleSingleTap:(UIGestureRecognizer*)ges
{
    
   
    if(![upgradeCenter isAutomaticShootingActivated])
        [self shootBullet];
}

#pragma mark - Core Methods

-(void)shootSideBullets
{
    CGPoint p=_spaceShip.position;
    p.y-=5;
    p.x -= 15;
    
    SKEmitterNode* fireParticlesL = [GameObject newExplosionEmitter];
    fireParticlesL.position = p;
    fireParticlesL.particleScale = 0.0001;
    fireParticlesL.numParticlesToEmit = 20;
    [_layerSpaceShipBulletsNode addChild:fireParticlesL];
    
    SpaceShipBullet *bulletLeft = [[SpaceShipBullet alloc]initWithPosition:p];
    [bulletLeft runAction:[self normalSpaceShipBulletAction]];
    [_layerSpaceShipBulletsNode addChild:bulletLeft];
    
    p.x += 30;
    
    SKEmitterNode* fireParticlesR = [GameObject newExplosionEmitter];
    fireParticlesR.position = p;
    fireParticlesR.particleScale = 0.0001;
    fireParticlesR.numParticlesToEmit = 20;
    fireParticlesR.particleColor = [UIColor blueColor];
    [_layerSpaceShipBulletsNode addChild:fireParticlesR];
    
    SpaceShipBullet *bulletRight = [[SpaceShipBullet alloc]initWithPosition:p];
    [bulletRight runAction:[self normalSpaceShipBulletAction]];
    [_layerSpaceShipBulletsNode addChild:bulletRight];
}

-(void)shootBullet
{
    CGPoint p=_spaceShip.position;
    p.y+=25;
    
    SKEmitterNode* fireParticles = [GameObject newExplosionEmitter];
    fireParticles.position = p;
    fireParticles.particleScale = 0.001;
    fireParticles.numParticlesToEmit = 50;
    [_layerSpaceShipBulletsNode addChild:fireParticles];
    
    SpaceShipBullet *bullet = [[SpaceShipBullet alloc]initWithPosition:p];
    [bullet runAction:[self normalSpaceShipBulletAction]];
    [_layerSpaceShipBulletsNode addChild:bullet];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    
    if(_gameRunning) {
        
        SKNode *contactNode1 = contact.bodyA.node;
        SKNode *contactNode2 = contact.bodyB.node;
        [self handleDeadEnemies:contact];
        [self handleSpaceShipDestroyed:contact];
        if([contactNode1 isKindOfClass:[GameObject class]]) {
            [(GameObject *)contactNode1 collidedWith:contact.bodyB contact:contact];
        }
        if([contactNode2 isKindOfClass:[GameObject class]]) {
            [(GameObject *)contactNode2 collidedWith:contact.bodyA contact:contact];
        }
    }
}

- (void) handleSpaceShipDestroyed:(SKPhysicsContact *)contact
{
    //if(([contact.bodyA.node isKindOfClass:[SpaceShip class]]&&((SpaceShip *)contact.bodyA.node).health==1)||([contact.bodyB.node isKindOfClass:[EnemyShip class]]&&((SpaceShip *)contact.bodyB.node).health==1))
   // {
     //   [self spaceShipIsDestroyed];
   // }
    
}

- (void) handleDeadEnemies:(SKPhysicsContact *)contact
{
        if([contact.bodyA.node isKindOfClass:[EnemyShip class]]||[contact.bodyB.node isKindOfClass:[EnemyShip class]])
           {
                    amountDeadEnemiesInTheCurrentLevel++;
              }
    }

- (void)didEndContact:(SKPhysicsContact *)contact
{    
    
}

-(void)removeOutOfScreenEnemiesInDeadEnemiesCount:(NSTimeInterval)currentTime
{
        NSArray *allEnemies=[self.layerEnemiesNode children];
        if ([allEnemies count] > 0)
            {
                for(EnemyShip* enemyShip in allEnemies)
                {
                    if(![enemyShip isKindOfClass:[EnemyShip class]])
                        continue;
                    if(enemyShip.enemyMovement==EnemyMovementNormal && enemyShip.position.y<=1)
                    {
                        [enemyShip removeFromParent];
                        amountDeadEnemiesInTheCurrentLevel++;
                    }
                    else  if(enemyShip.enemyMovement==EnemyMovementRightArc && enemyShip.position.x<=-5)
                    {
                        [enemyShip removeFromParent];
                        amountDeadEnemiesInTheCurrentLevel++;
                    }
                    else if(enemyShip.enemyMovement==EnemyMovementLeftArc && enemyShip.position.x>=325)
                    {
                        [enemyShip removeFromParent];
                        amountDeadEnemiesInTheCurrentLevel++;
                    }
                }
            }
}

-(void)update:(CFTimeInterval)currentTime {
 /* Called before each frame is rendered */
    
    _layerSecondBackground.position = CGPointMake(_layerSecondBackground.position.x, _layerSecondBackground.position.y-1);
    _layerFirstBackground.position = CGPointMake(_layerSecondBackground.position.x, _layerFirstBackground.position.y-1);
    
    if(_layerSecondBackground.position.y <= -1*self.size.height)
        _layerSecondBackground.position = CGPointMake(0, self.size.height);
    
    if(_layerFirstBackground.position.y <= -1*self.size.height)
        _layerFirstBackground.position = CGPointMake(0, self.size.height);
    [self rotateShipsThatNeedRotation:currentTime];
    [self fireEnemiesBulletsEveryUpdate:currentTime];
    [self removeOutOfScreenEnemiesInDeadEnemiesCount:currentTime];
}



#pragma mark - Adding Enemies

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
   // EnemyShip *ff=[EnemyFactory CreateEnemies:EnemyTypeXTroyer AndTheMovement:EnemyMovementRightArc];
    
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

-(void) addXStarEnemyRightArc
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXStar AndTheMovement:EnemyMovementRightArc]];
}

-(void) addXStarEnemyLeftArc
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXStar AndTheMovement:EnemyMovementLeftArc]];
}

-(void) addXBoosterEnemy
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXBooster AndTheMovement:EnemyMovementNormal]];
}

-(void) addXBoosterEnemyRightArc
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXBooster AndTheMovement:EnemyMovementRightArc]];
}

-(void) addXBoosterEnemyLeftArc
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXBooster AndTheMovement:EnemyMovementLeftArc]];
}

-(void) addXCornerEnemy
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXCorner AndTheMovement:EnemyMovementNormal]];
}

-(void) addXCornerEnemyRightArc
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXCorner AndTheMovement:EnemyMovementRightArc]];
}

-(void) addXCornerEnemyLeftArc
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXCorner AndTheMovement:EnemyMovementLeftArc]];
}

-(void) addXDollarEnemy
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXDollar AndTheMovement:EnemyMovementNormal]];
}

-(void) addXDollarEnemyRightArc
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXDollar AndTheMovement:EnemyMovementRightArc]];
}

-(void) addXDollarEnemyLeftArc
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXDollar AndTheMovement:EnemyMovementLeftArc]];
}

#pragma mark -EnemyBullet And Rotation Handling

-(void)rotateShipsThatNeedRotation:(NSTimeInterval)currentTime
{
    NSArray *allEnemies=[self.layerEnemiesNode children];
    if ([allEnemies count] > 0)
    {
        SpaceShip* ship = [[_layerPlayerNode children] objectAtIndex:0];
        for(EnemyShip* enemyShip in allEnemies)
        {
            if(![enemyShip isKindOfClass:[EnemyShip class]]||enemyShip.enemyMovement==EnemyMovementNormal)
                continue;
            float angle = atan((enemyShip.position.y - ship.position.y)/((enemyShip.position.x - ship.position.x)*1.0));
            
            if(enemyShip.position.x > ship.position.x)
            enemyShip.zRotation = angle+3*M_PI/2.0;
            else enemyShip.zRotation = angle+M_PI/2.0;
        }
    }
}

-(void)fireEnemiesBulletsEveryUpdate:(NSTimeInterval)currentTime
{
    NSMutableArray *allEnemies=[self getEnemys];
    if ([allEnemies count] > 0)
    {
        int allInvadersIndex = arc4random()%([allEnemies count]);
        EnemyShip* enemy = [allEnemies objectAtIndex:allInvadersIndex];
        double numberBetweenZeroAndOne = drand48();
        if(numberBetweenZeroAndOne<enemy.probabilityToShoot)
        {
            [self HandleEachEnemyShootingTechnique:enemy];
        }
    }
}


-(NSMutableArray *)getEnemys
{
    NSMutableArray* allEnemies = [NSMutableArray array];
    [_layerEnemiesNode.children enumerateObjectsUsingBlock:^(SKNode *node,NSUInteger idx, BOOL *stop)
     {
         NSArray* allNames=[[NSArray alloc] initWithObjects:@"EnemyXRuser",@"EnemyXTroyer",@"EnemyXDollar",@"EnemyXCorner",@"EnemyXBooster",@"EnemyXStar", nil];
         if([allNames containsObject:node.name])
         {
              [allEnemies addObject:node];
         }
     }];
    return allEnemies;
}

-(NSMutableArray *)getEnemys:(NSString *) enemyType
{
    NSMutableArray* allEnemies = [NSMutableArray array];
    [_layerEnemiesNode.children enumerateObjectsUsingBlock:^(SKNode *node,NSUInteger idx, BOOL *stop)
     {
         if([enemyType isEqualToString:node.name])
         {
             [allEnemies addObject:node];
         }
     }];
    return allEnemies;
}

-(void) HandleEachEnemyShootingTechnique:(EnemyShip*)enemyShip
{
    /*
    if(enemyShip.enemyMovement==EnemyMovementNormal)
    {
        CGPoint p = CGPointMake(enemyShip.position.x, enemyShip.position.y);
        SKNode* bullet = [[EnemyShipBullet alloc]initWithPosition:p];
        CGPoint bulletDestination = CGPointMake(enemyShip.position.x, 0);
        double duration =enemyShip.position.y/100 *0.5;
        [self fireBullet:bullet toDestination:bulletDestination withDuration:duration soundFileName:@"InvaderBullet.wav"];
    }
    else if(enemyShip.enemyMovement==EnemyMovementLeftArc || enemyShip.enemyMovement==EnemyMovementRightArc)
    {
        CGPoint p = CGPointMake(enemyShip.position.x, enemyShip.position.y);
        SKNode* bullet = [[EnemyShipBullet alloc]initWithPosition:p];
        CGPoint bulletDestination = CGPointMake(_spaceShip.position.x, _spaceShip.position.y);
        double duration =enemyShip.position.y/100 *0.5;
        [self fireBullet:bullet toDestination:bulletDestination withDuration:duration soundFileName:@"InvaderBullet.wav"];
    }*/
    
    
    ////////////////////
    
    if(enemyShip.enemyMovement==EnemyMovementNormal)
    {
        CGPoint p = CGPointMake(enemyShip.position.x, enemyShip.position.y);
        SKNode* bullet = [[EnemyShipBullet alloc]initWithPosition:p];
        CGPoint bulletDestination = CGPointMake(enemyShip.position.x, 0);
        double duration =enemyShip.position.y/100 *0.5;
        [self fireBullet:bullet toDestination:bulletDestination withDuration:duration soundFileName:@"InvaderBullet.wav"];
    }
    else
    {
    CGPoint p = CGPointMake(enemyShip.position.x, enemyShip.position.y);
    SKNode* bullet = [[EnemyShipBullet alloc]initWithPosition:p];
    CGPoint bulletDestination;
    int x1,x2,y1,y2,a,b,moveToX,moveToY,distanceTraveled;
    
    x1 = enemyShip.position.x;
    y1 = enemyShip.position.y;
    x2 = _spaceShip.position.x;
    y2 = _spaceShip.position.y;
    
    a = (y2 - y1)/(1.0*(x2-x1));
    b = ((y1*x2)-(y2*x1))/(1.0*(x2-x1));
    
    if(x1 < x2)
    {
        moveToX = self.view.bounds.size.width + 50;
        moveToY = a*moveToX + b;
        distanceTraveled = sqrt(pow(moveToX - enemyShip.position.x,2)+pow(enemyShip.position.y-moveToY,2));
    }
    else
    {
        moveToX = -50;
        moveToY = a*moveToX + b;
        distanceTraveled = sqrt(pow(moveToX + enemyShip.position.x,2)+pow(enemyShip.position.y-moveToY,2));
    }
    bulletDestination = CGPointMake(moveToX, moveToY);
    double duration =distanceTraveled/150;
    
    [self fireBullet:bullet toDestination:bulletDestination withDuration:duration soundFileName:@"InvaderBullet.wav"];
    }
    
    ///////////////////
    
}

-(void)fireBullet:(SKNode*)bullet toDestination:(CGPoint)destination withDuration:(NSTimeInterval)duration soundFileName:(NSString*)soundFileName
{
    float angle = atan((destination.y-bullet.position.y)/(1.0*(destination.x-bullet.position.x)));
   
    if(bullet.position.x<destination.x)
        angle = angle+M_PI;
    else if(bullet.position.x == destination.x)
        angle = M_PI/2;
    
    ((EnemyShipBullet*)bullet).emitter.emissionAngle = angle;
    SKAction* bulletAction = [SKAction sequence:@[[SKAction moveTo:destination duration:duration],
                                                  [SKAction removeFromParent]]];
    
    
    //SKAction* soundAction  = [SKAction playSoundFileNamed:soundFileName waitForCompletion:YES];
    [bullet runAction:[SKAction group:@[bulletAction]]];//,soundAction
    [self addChild:bullet];
}

#pragma mark - Handle High Scores
-(void)storeHighScores:(float)score {

    NSSortDescriptor *sortedScores = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    [storedScores sortUsingDescriptors:[NSArray arrayWithObject:sortedScores]];
    
    if (score > [[storedScores objectAtIndex:9] floatValue]) {
        [storedScores replaceObjectAtIndex:9 withObject:[NSNumber numberWithFloat:score]];
    }
    
    [self writeToPlist:@"Scores.plist" withData:storedScores];
    
    
}

//method to save the NS Array to Plist

- (void) writeToPlist: (NSString*)fileName withData:(NSMutableArray *)data
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    [data writeToFile:finalPath atomically: YES];

}

//method to retreive the NS Array to Plist
- (NSMutableArray *) readFromPlist: (NSString *)fileName {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:finalPath];
    
    if (fileExists) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithContentsOfFile:finalPath];
        return arr;
    } else {
        return nil;
    }
}

@end
