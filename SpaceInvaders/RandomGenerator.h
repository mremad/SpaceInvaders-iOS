//
//  RandomGenerator.h
//  SpaceInvaders
//
//  Created by M on 12/4/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomGenerator : NSObject


+(int)getNumberOfWaves:(int)level;
+(int)getSizeOfWave:(int)indexOfWave numberOfWaves:(int) waves;
+(int)getCountOfWave:(int)indexOfWave numberOfWaves:(int) waves;
+(SEL)getSelectorGivenSelectorArrays:(NSArray *)arrOfArrays AndLevel:(int)level AndWave:(int)wave;
@end
