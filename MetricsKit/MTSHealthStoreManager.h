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
