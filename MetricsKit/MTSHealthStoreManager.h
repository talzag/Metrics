//
//  MTSHealthDataCoordinator.h
//  Metrics
//
//  Created by Daniel Strokis on 3/15/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

@interface MTSHealthStoreManager : NSObject

+ (void)requestReadAccessForHealthStore:(HKHealthStore * _Nonnull)healthStore completionHandler:(void (^ _Nonnull)(BOOL success, NSError * _Nullable error))completionHandler;

@end
