//
//  MTSHealthDataCoordinator.h
//  Metrics
//
//  Created by Daniel Strokis on 3/15/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>
#import "MTSHealthData+CoreDataClass.h"

/**
 Contains the logic for determining which health data can be grouped together.
 This is useful when looking at related types of data. For example, a user could group
 HKQuantityTypeIdentifierBasalEnergyBurned and HKQuantityTypeIdentifierActiveEnergyBurned
 together, then subtract HKQuantityTypeIdentifierDietaryEnergyConsumed to see their "real" 
 calorie count for a given time period.
 */
@interface MTSHealthDataCoordinator : NSObject

/**
 Determines whether the data of one MTSHealthData instance can be combined with the the data of
 another MTSHealthData instance and treated as a single set of data to be graphed. Currently the 
 only data that can be combined is health data related to calories:
 
 Base Calories Burned + Active Calories Burned - Dietary Calories Consumed = Real Calorie difference

 @param typeA MTSHealthData instance
 @param typeB MTSHealthData instance
 @return YES if the data from both types can be combined, NO otherwise.
 */
- (BOOL)healthData:(MTSHealthData *)typeA canBeGroupedWithHealthType:(MTSHealthData *)typeB;


- (NSDictionary <NSString *, HKQuantityTypeIdentifier> *)groupableHealthTypesForHealthData:(MTSHealthData *)healthData;

@end
