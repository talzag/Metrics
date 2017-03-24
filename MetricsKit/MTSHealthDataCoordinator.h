//
//  MTSHealthDataCoordinator.h
//  Metrics
//
//  Created by Daniel Strokis on 3/15/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

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

 @param typeA Identifier A
 @param typeB Identifier B
 @return YES if the data of both types can be combined, NO otherwise.
 */
+ (BOOL)healthType:(_Nonnull HKQuantityTypeIdentifier)typeA canBeGroupedWithHealthType:(_Nonnull HKQuantityTypeIdentifier)typeB;

/**
 <#Description#>

 @param healthStore <#healthStore description#>
 @param completionHandler <#completionHandler description#>
 */
+ (void)requestReadAccessForHealthStore:(HKHealthStore * _Nonnull)healthStore completionHandler:(void (^ _Nonnull)(BOOL success, NSError * _Nullable error))completionHandler;

/**
 <#Description#>

 @param healthStore <#healthStore description#>
 @param typeIdentifier <#typeIdentifier description#>
 @param startDate <#startDate description#>
 @param endDate <#endDate description#>
 @param completionHandler <#completionHandler description#>
 */
+ (void)queryHealthStore:(HKHealthStore * _Nonnull)healthStore
         forQuantityType:(HKQuantityTypeIdentifier _Nonnull)typeIdentifier
                fromDate:(NSDate * _Nonnull)startDate
                  toDate:(NSDate * _Nonnull)endDate
  usingCompletionHandler:(void (^ _Nonnull)(NSArray <__kindof NSDictionary *>* _Nullable samples)) completionHandler;

@end
