//
//  EnemyFactory.m
//  SpaceInvaders
//
//  Created by M on 11/27/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "EnemyFactory.h"

@implementation EnemyFactory


+ (EnemyFactory *)sharedFactory {
    static EnemyFactory *sharedFactory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFactory = [[self alloc] init];
    });
    return sharedFactory;
}

+(EnemyShip *)CreateRandomEnemy
{
    int modulo3Number = arc4random()%3;
    CGPoint myPoint = [self getRandomAcceptablePointForEnemiesComingFromTheTop];
    EnemyMovement movement = EnemyMovementNormal;
    switch (modulo3Number)
    {
        case 0:
            return [self CreateEnemyXRuserWithMovement:movement AndThePosition:myPoint];
            break;
        case 1:
            return [self CreateEnemyXTroyerWithMovement:movement AndThePosition:myPoint];
            break;
        default:
            return [self CreateEnemyXStarWithMovement:movement AndThePosition:myPoint];
    }
}



+(NSArray *)CreateEnemies:(EnemyType) enemyType AndTheMovement:(EnemyMovement)movement AndTheirPositions:(NSArray *) myCGPointArray
{
    //NSArray *myCGPointArray = [[NSArray alloc] initWithObjects:[NSValue valueWithCGPoint:CGPointMake(30.0, 150.0)],[NSValue valueWithCGPoint:CGPointMake(41.67, 145.19)], nil];
    
    NSMutableArray *enemiesResultArray = [NSMutableArray array];
    for(int i =0;i<[myCGPointArray count];i++)
    {
        CGPoint myPoint = [[myCGPointArray objectAtIndex:i] CGPointValue];
        EnemyShip *enemy;
        switch (enemyType)
        {
            case EnemyTypeXRuser:
            {
                enemy=[self CreateEnemyXRuserWithMovement:movement AndThePosition:myPoint];
                break;
            }
            case EnemyTypeXTroyer:
            {
                enemy=[self CreateEnemyXTroyerWithMovement:movement AndThePosition:myPoint];
                break;
            }
            default:
            {
                enemy=[self CreateEnemyXStarWithMovement:movement AndThePosition:myPoint];
                break;
            }
        }
        [enemiesResultArray addObject:enemy];
    }
    return enemiesResultArray;
}

+ (NSArray *)CreateEnemies:(EnemyType) enemyType AndTheMovement:(EnemyMovement)movement AndTheirAmount:(int) amount
{
    NSMutableArray *cGPointsArray = [NSMutableArray arrayWithCapacity:amount];
    
    for(int i=0;i<amount ;i++)
    {
        [cGPointsArray insertObject:[NSValue valueWithCGPoint:[self getPossibleCGPoint:movement]] atIndex:i];
    }
    
    return [self CreateEnemies:enemyType AndTheMovement:movement AndTheirPositions:cGPointsArray];
}

+ (EnemyShip *)CreateEnemies:(EnemyType) enemyType AndTheMovement:(EnemyMovement)movement
{
    return [[self CreateEnemies:enemyType AndTheMovement:movement AndTheirAmount:1] objectAtIndex:0];
}
+(SKAction *) EnemyBehaviourNormal
{
    SKAction *moveAction = [SKAction moveToY:-100 duration:8]; //TODO set appropiate numbers (duration and moveTo handle ultamately the speed.. .. used for the upgrade for ex)
    SKAction *removeEnemy= [SKAction removeFromParent];
    SKAction *enemySequence = [SKAction sequence:@[moveAction, removeEnemy]];
    return enemySequence;
}

+(SKAction *) EnemyBehaviourArcLikeGivenYPosition:(CGFloat) xPosition AndYPosition:(CGFloat)yPosition
{
    CGMutablePathRef ff=[self drawPathWithArcGivenYPosition:xPosition AndYPosition:yPosition];
    SKAction *moveAction = [SKAction followPath:ff asOffset:YES orientToPath:YES duration:5];
    SKAction *removeEnemy= [SKAction removeFromParent];
    SKAction *enemySequence = [SKAction sequence:@[moveAction, removeEnemy]];
    return enemySequence;
}

+ (CGMutablePathRef )drawPathWithArcGivenYPosition:(CGFloat) xPosition AndYPosition:(CGFloat)yPosition
{
    CGMutablePathRef thePath =CGPathCreateMutable();
    CGPathAddArc(thePath, NULL, 200.f, yPosition, 200.f, M_PI, 0.f, NO);
    return thePath;
}

+(CGPoint) getPossibleCGPoint:(EnemyMovement) movement
{
    if(movement==EnemyMovementNormal)
    {
        return [self getRandomAcceptablePointForEnemiesComingFromTheTop];
    }
    else
    {
        return [self getRandomAcceptablePointForArcEnemiesComingFromTheLeft];
    }
}

+(EnemyShip *)CreateEnemyXRuserWithMovement :(EnemyMovement)movement
{
    CGPoint p=[self getPossibleCGPoint:movement];
    return [self CreateEnemyXRuserWithMovement:movement AndThePosition:p];
}

+(EnemyShip *)CreateEnemyXRuserWithMovement :(EnemyMovement)movement AndThePosition:(CGPoint)point
{
    EnemyShip *ship = [[XRuser alloc]initWithPosition:point];
    [self runAppropiateAction:ship WithMovemement:movement];
    return ship;
}


+(EnemyShip *)CreateEnemyXTroyerWithMovement :(EnemyMovement)movement
{
    CGPoint p=[self getPossibleCGPoint:movement];
    return [self CreateEnemyXTroyerWithMovement:movement AndThePosition:p];
}

+(EnemyShip *)CreateEnemyXTroyerWithMovement :(EnemyMovement)movement AndThePosition:(CGPoint)point
{
    EnemyShip *ship = [[XTroyer alloc]initWithPosition:point];
    [self runAppropiateAction:ship WithMovemement:movement];
    return ship;
}


+(EnemyShip *)CreateEnemyXStarWithMovement :(EnemyMovement)movement
{
    CGPoint p=[self getPossibleCGPoint:movement];
    return [self CreateEnemyXStarWithMovement:movement AndThePosition:p];
}

+(EnemyShip *)CreateEnemyXStarWithMovement :(EnemyMovement)movement AndThePosition:(CGPoint)point
{
    EnemyShip *ship = [[XStar alloc]initWithPosition:point];
    [self runAppropiateAction:ship WithMovemement:movement];
    return ship;
}

+(void)runAppropiateAction:(EnemyShip*) ship WithMovemement:(EnemyMovement) movement
{
    if(movement==EnemyMovementNormal)
    {
        [ship runAction:[self EnemyBehaviourNormal]];
    }
    else if(movement==EnemyMovementArc)
    {
        ship.position=CGPointMake(0, ship.position.y);
        [ship runAction:[self EnemyBehaviourArcLikeGivenYPosition:ship.position.x AndYPosition:ship.position.y]];
    }
}

+(CGPoint) getRandomAcceptablePointForEnemiesComingFromTheTop
{
    int Xmin = 20;
    int Xmax = 300;
    int XInBetween = Xmin+(arc4random()%(Xmax-Xmin));
    
    return CGPointMake(XInBetween, 500);
}

+(CGPoint) getRandomAcceptablePointForArcEnemiesComingFromTheLeft
{
    int Ymin = 180;
    int Ymax = 250;
    int YInBetween = Ymin+(arc4random()%(Ymax-Ymin));
    
    int Xmin = 20;
    int Xmax = 300;
    int XInBetween = Xmin+(arc4random()%(Xmax-Xmin));
    
    return CGPointMake(XInBetween, YInBetween);
}


- (id)init
{
    self = [super init];
    if(self==nil)
    {
        NSLog(@"Error in th initializer of EnemyFactory");
    }
    return self;
}

@end
