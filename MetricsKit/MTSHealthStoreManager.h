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

+ (void)queryHealthStore:(HKHealthStore * _Nonnull)healthStore
         forQuantityType:(HKQuantityTypeIdentifier _Nonnull)typeIdentifier
                fromDate:(NSDate * _Nonnull)startDate
                  toDate:(NSDate * _Nonnull)endDate
  usingCompletionHandler:(void (^ _Nonnull)(NSArray * _Nullable samples)) completionHandler;

@end
