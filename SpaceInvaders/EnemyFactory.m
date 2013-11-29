//
//  EnemyFactory.m
//  SpaceInvaders
//
//  Created by M on 11/27/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "EnemyFactory.h"

@implementation EnemyFactory
{
    
}

EnemyMovement movement = MovementArc;
int amountOfEnemysToStartFromSamePosition=3,amountOfEnemiesCreatedInSamePositionCounter=0; //must be the same..

CGPoint lastPoint;


+ (EnemyFactory *)sharedFactory {
    static EnemyFactory *sharedFactory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFactory = [[self alloc] init];
    });
    return sharedFactory;
}

+ (void) setAmountOfEnemysToStartFromSamePosition:(int) amount
{
    amountOfEnemysToStartFromSamePosition=amount;
}


+(EnemyShip *)CreateSingleRandomEnemy
{
    int modulo3Number = arc4random()%3;
    switch (modulo3Number) {
        case 0:
            return [self CreateEnemyXRuser];
            break;
        case 1:
            return [self CreateEnemyXTroyer];
            break;
        default:
            return [self CreateEnemyXStar];
    }
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
    //CGPathAddArc(<#CGMutablePathRef path#>, <#const CGAffineTransform *m#>, <#CGFloat x#>, <#CGFloat y#>, <#CGFloat radius#>, <#CGFloat startAngle#>, <#CGFloat endAngle#>, <#bool clockwise#>)
    return thePath;
}

+(EnemyShip *)CreateEnemyXRuser
{
    EnemyShip *ship = [[XRuser alloc]initWithPosition:[self getRandomOrFixedPoint]];
    [self runAppropiateAction:ship];
    return ship;
}

+(EnemyShip *)CreateEnemyXTroyer
{
    EnemyShip *ship = [[XTroyer alloc]initWithPosition:[self getRandomOrFixedPoint]];
    [self runAppropiateAction:ship];
    return ship;
}

+(EnemyShip *)CreateEnemyXStar
{
    EnemyShip *ship = [[XStar alloc]initWithPosition:[self getRandomOrFixedPoint]];
    [self runAppropiateAction:ship];
    return ship;
}

+(void)runAppropiateAction:(EnemyShip*) ship
{
    if(movement==MovementNormal)
    {
         [ship runAction:[self EnemyBehaviourNormal]];
    }
    else if(movement==MovementArc)
    {
        ship.position=CGPointMake(0, ship.position.y);
        [ship runAction:[self EnemyBehaviourArcLikeGivenYPosition:ship.position.x AndYPosition:ship.position.y]];
    }
}

+(CGPoint) getRandomOrFixedPoint
{
    if(amountOfEnemiesCreatedInSamePositionCounter==0)
    {
       
        amountOfEnemiesCreatedInSamePositionCounter=amountOfEnemysToStartFromSamePosition;
        if(movement==MovementNormal)
        {
            [self generateRandomAcceptablePointForTopEnemies];
        }
        else if(movement==MovementArc)
        {
            [self generateRandomAcceptablePointForArcEnemies];
        }
    }
    else
    {
        amountOfEnemiesCreatedInSamePositionCounter--;
    }
    
    return lastPoint;
}


+(void) generateRandomAcceptablePointForTopEnemies
{
    
    int Xmin = 20;
    int Xmax =300;
    int XInBetween=Xmin+(arc4random()%(Xmax-Xmin));
    
    lastPoint=CGPointMake(XInBetween, 500);
}

+(void) generateRandomAcceptablePointForArcEnemies
{
    int Ymin = 180;
    int Ymax = 250;
    int YInBetween=Ymin+(arc4random()%(Ymax-Ymin));
    
    int Xmin = 20;
    int Xmax =300;
    int XInBetween=Xmin+(arc4random()%(Xmax-Xmin));
    
    lastPoint=CGPointMake(XInBetween, YInBetween);
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
