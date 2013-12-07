//
//  Upgrade.h
//  SpaceInvaders
//
//  Created by M on 11/27/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Upgrade : NSObject

//possible states of UpgradeValues
typedef enum UpgradeValues {UpgradeFreeze,
    UpgradeAutomaticShooting,
    UpgradeDestroyAllEnemys} UpgradeValues;

@end
