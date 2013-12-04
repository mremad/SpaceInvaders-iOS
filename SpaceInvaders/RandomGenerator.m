//
//  RandomGenerator.m
//  SpaceInvaders
//
//  Created by M on 12/4/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "RandomGenerator.h"

#define luckynumber 3

@implementation RandomGenerator


- (id)init
{
    self = [super init];
    if(self==nil)
    {
        NSLog(@"Error in th initializer of Random Generator");
    }
    return self;
}



+(int)getNumberOfWaves:(int)level
{
    int minWave = MIN(level%luckynumber,level);
    int numberOfWaves = minWave + arc4random()%luckynumber;
    return MAX(numberOfWaves,1);
}

+(SEL)getSelectorGivenSelectorArrays:(NSArray *)arrOfArrays AndLevel:(int)level AndWave:(int)wave
{
   
    int indexOfArray = arc4random()%3;
    NSMutableArray *arrX = [arrOfArrays objectAtIndex:indexOfArray];
    int arraySize=[arrX count];
    int totallyRandomNumber = (wave + level + (arc4random()%luckynumber))%arraySize; //TODO maybe change that..
    int finalIndex =MIN(MIN(totallyRandomNumber,level),arraySize);
    NSString *str = [arrX objectAtIndex:finalIndex];
    return  NSSelectorFromString(str);
}


+(int)getSizeOfWave:(int)indexOfWave numberOfWaves:(int) waves
{
    int OneOrZero = 2*drand48(); //TODO Check if true
    return MAX(indexOfWave+1,indexOfWave+1-OneOrZero);
}

+(int)getCountOfWave:(int)indexOfWave numberOfWaves:(int) waves
{
    return 5*(indexOfWave+1);
}

@end
