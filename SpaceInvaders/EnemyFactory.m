//
//  EnemyFactory.m
//  SpaceInvaders
//
//  Created by M on 11/27/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "EnemyFactory.h"

@implementation EnemyFactory
//some constants
          int enemyMovementNormalY;
    const int enemyMovementLeftArcX=0;
    const int enemyMovementRightArcX=-50; //this requires some more work to undersand how the arc is generated , but for now I tried out random numbers till I got it to look good

    
- (id)init
{
    self = [super init];
    if(self==nil)
    {
        enemyMovementNormalY=[define IPhoneStartsAtThisYPosition] ;
        NSLog(@"Error in th initializer of EnemyFactory");
    }
    return self;
}

#pragma mark Creating Enemies


+(EnemyShip *)CreateRandomEnemy
{
    int modulo3Number = arc4random()%3;
    CGPoint myPoint = [self getRandomAcceptablePointForEnemiesComingFromTheTop];
    EnemyMovement movement = EnemyMovementNormal;
    switch (modulo3Number)
    {
            //TODO add other ships..
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
            case EnemyTypeXBooster:
            {
                enemy=[self CreateEnemyXBoosterWithMovement:movement AndThePosition:myPoint];
                break;
            }
            case EnemyTypeXDollar:
            {
                enemy=[self CreateEnemyXDollarWithMovement:movement AndThePosition:myPoint];
                break;
            }
            case EnemyTypeXCorner:
            {
                enemy=[self CreateEnemyXCornerWithMovement:movement AndThePosition:myPoint];
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


+(EnemyShip *)CreateEnemyXRuserWithMovement :(EnemyMovement)movement AndThePosition:(CGPoint)point
{
    EnemyShip *ship =[[XRuser alloc]initWithPosition:point];
    ship.enemyMovement=movement;
    [self runAppropiateAction:ship WithMovemement:movement];
    return ship;
}

+(EnemyShip *)CreateEnemyXTroyerWithMovement :(EnemyMovement)movement AndThePosition:(CGPoint)point
{
    EnemyShip *ship = [[XTroyer alloc]initWithPosition:point];
    ship.enemyMovement=movement;
    [self runAppropiateAction:ship WithMovemement:movement];
    return ship;
}

+(EnemyShip *)CreateEnemyXStarWithMovement :(EnemyMovement)movement AndThePosition:(CGPoint)point
{
    EnemyShip *ship = [[XStar alloc]initWithPosition:point];
    ship.enemyMovement=movement;
    [self runAppropiateAction:ship WithMovemement:movement];
    return ship;
}

+(EnemyShip *)CreateEnemyXBoosterWithMovement :(EnemyMovement)movement AndThePosition:(CGPoint)point
{
    EnemyShip *ship = [[XBooster alloc]initWithPosition:point];
    ship.enemyMovement=movement;
    [self runAppropiateAction:ship WithMovemement:movement];
    return ship;
}

+(EnemyShip *)CreateEnemyXDollarWithMovement :(EnemyMovement)movement AndThePosition:(CGPoint)point
{
    EnemyShip *ship = [[XDollar alloc]initWithPosition:point];
    ship.enemyMovement=movement;
    [self runAppropiateAction:ship WithMovemement:movement];
    return ship;
}

+(EnemyShip *)CreateEnemyXCornerWithMovement :(EnemyMovement)movement AndThePosition:(CGPoint)point
{
    EnemyShip *ship = [[XCorner alloc]initWithPosition:point];
    ship.enemyMovement=movement;
    [self runAppropiateAction:ship WithMovemement:movement];
    return ship;
}


#pragma mark Point Handling


+(CGPoint) getPossibleCGPoint:(EnemyMovement) movement
{
    if(movement==EnemyMovementNormal)
    {
        return [self getRandomAcceptablePointForEnemiesComingFromTheTop];
    }
    else if(movement == EnemyMovementLeftArc)
    {
        return [self getRandomAcceptablePointForArcEnemiesComingFromTheLeft];
    }
    else
    { //movement == EnemyMovementRightArc
        return [self getRandomAcceptablePointForArcEnemiesComingFromTheRight];
    }
}

+(CGPoint) getRandomAcceptablePointForEnemiesComingFromTheTop
{
    int Xmin = 20;
    int Xmax = 300;
    int XInBetween = Xmin+(arc4random()%(Xmax-Xmin));
    
    return CGPointMake(XInBetween, enemyMovementNormalY);
}

+(CGPoint) getRandomAcceptablePointForArcEnemiesComingFromTheLeft
{
    int Ymin = 180;
    int Ymax = 250;
    int YInBetween = Ymin+(arc4random()%(Ymax-Ymin));
    
    return CGPointMake(enemyMovementLeftArcX, YInBetween);
}

+(CGPoint) getRandomAcceptablePointForArcEnemiesComingFromTheRight
{
    int Ymin = 180;
    int Ymax = 250;
    int YInBetween = Ymin+(arc4random()%(Ymax-Ymin));
    
    return CGPointMake(enemyMovementRightArcX, YInBetween);
}
#pragma mark SKActions

+(SKAction *) EnemyBehaviourNormal
{
    SKAction *moveAction = [SKAction moveToY:0 duration:6]; //TODO set appropiate numbers (duration and moveTo handle ultamately the speed.. .. used for the upgrade for ex)
    SKAction *removeEnemy= [SKAction removeFromParent];
    SKAction *enemySequence = [SKAction sequence:@[moveAction, removeEnemy]];
    return enemySequence;
}

+(SKAction *) EnemyBehaviourNormalX:(EnemyShip*)ls
{
    SKAction *moveAction = [SKAction moveToY:0 duration:6]; //TODO set appropiate numbers (duration and moveTo handle ultamately the speed.. .. used for the upgrade for ex)
    SKAction *removeEnemy= [SKAction removeFromParent];
/*    SKAction* blinkAction = [SKAction runBlock:^
                             {
                                 CGPoint p=ls.position;
                                 p.y+=5;
                                 EnemyShipBullet *bullet = [[EnemyShipBullet alloc]initWithPosition:p];
                                 //Move the bullet down the screen and remove it when it is of screen
                                 SKAction *moveAction = [SKAction moveToY:1000 duration:3];//TODO set appropiate numbers (duration and moveTo handle ultamately the speed.. .. used for the upgrade for ex)
                                 SKAction *removeBullet= [SKAction removeFromParent];
                                 SKAction *bulletSequence = [SKAction sequence:@[moveAction, removeBullet]];
                                 [bullet runAction:bulletSequence];
                                 
                             }
                             ];*/
    SKAction *enemySequence = [SKAction sequence:@[moveAction, removeEnemy]];
    return enemySequence;
}

/*-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint p=_spaceShip.position;
    p.y+=5;
    
    SpaceShipBullet *bullet = [[SpaceShipBullet alloc]initWithPosition:p];
    [bullet runAction:[self normalBulletAction]];
    [_layerSpaceShipBulletsNode addChild:bullet];
    
}


-(SKAction *) normalBulletAction
{
    //Move the bullet down the screen and remove it when it is of screen
    SKAction *moveAction = [SKAction moveToY:1000 duration:3];//TODO set appropiate numbers (duration and moveTo handle ultamately the speed.. .. used for the upgrade for ex)
    SKAction *removeBullet= [SKAction removeFromParent];
    SKAction *bulletSequence = [SKAction sequence:@[moveAction, removeBullet]];
    return bulletSequence;
}*/


+(SKAction *) EnemyBehaviourLeftArcGivenYPosition:(CGFloat)yPosition
{
    CGMutablePathRef thePath =CGPathCreateMutable();
    CGPathAddArc(thePath, NULL, 200.f, yPosition, 200.f, M_PI, 0.f, NO);
    SKAction *moveAction = [SKAction followPath:thePath asOffset:YES orientToPath:NO duration:5];
    SKAction *removeEnemy= [SKAction removeFromParent];
    SKAction *enemySequence = [SKAction sequence:@[moveAction, removeEnemy]];
    return enemySequence;
}

+(SKAction *) EnemyBehaviourRightArcGivenYPosition:(CGFloat)yPosition
{
    CGMutablePathRef thePath =CGPathCreateMutable();
    CGPathAddArc(thePath, NULL, 200.f, yPosition, 200.f, 0.f, M_PI, YES);//TODO these numbers are probably not the best suitable
    SKAction *moveAction = [SKAction followPath:thePath asOffset:YES orientToPath:NO duration:5];
    SKAction *removeEnemy= [SKAction removeFromParent];
    SKAction *enemySequence = [SKAction sequence:@[moveAction, removeEnemy]];
    return enemySequence;
}

+(void)runAppropiateAction:(EnemyShip*) ship WithMovemement:(EnemyMovement) movement
{
    if(movement==EnemyMovementNormal)
    {
        [ship runAction:[self EnemyBehaviourNormal]];
    }
    else if(movement==EnemyMovementLeftArc)
    {
        [ship runAction:[self EnemyBehaviourLeftArcGivenYPosition:ship.position.y]];
    }
    else if(movement==EnemyMovementRightArc)
    {
        [ship runAction:[self EnemyBehaviourRightArcGivenYPosition:ship.position.y]];
    }
}


@end
