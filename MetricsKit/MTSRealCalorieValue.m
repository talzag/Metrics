//
//  MTSRealCalorieValue.m
//  Metrics
//
//  Created by Daniel Strokis on 3/19/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSRealCalorieValue.h"

void queryHealthStore(HKHealthStore *healthStore, NSDate *start, NSDate *end, HKQuantityType *quantityType, void (^completionHandler)(double result, NSError *error)) {
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:start
                                                               endDate:end
                                                               options:HKQueryOptionNone];
    
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType
                                                                 quantitySamplePredicate:predicate
                                                                                 options:HKStatisticsOptionCumulativeSum
                                                                       completionHandler:^(HKStatisticsQuery * _Nonnull query, HKStatistics * _Nullable result, NSError * _Nullable error) {
                                                                           double total = [[result sumQuantity] doubleValueForUnit:[HKUnit kilocalorieUnit]];
                                                                           
                                                                           if (completionHandler) {
                                                                               completionHandler(total, error);
                                                                           }
                                                                       }];
    [healthStore executeQuery:query];
}

void MTSRealCalorieValue(HKHealthStore *healthStore, NSDate *start, NSDate *end, void (^completionHandler)(double, NSError *)) {
    HKQuantityType *baseEnergyBurned = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned];
    HKQuantityType *activeEnergyBurned = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *dietaryEnergyConsumed = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    
    queryHealthStore(healthStore, start, end, baseEnergyBurned, ^(double baseCalories, NSError *error) {
        queryHealthStore(healthStore, start, end, activeEnergyBurned, ^(double activeCalories, NSError *error) {
            queryHealthStore(healthStore, start, end, dietaryEnergyConsumed, ^(double consumedCalories, NSError *error) {
                double netCalories = consumedCalories - activeCalories - baseCalories;
                
                if (completionHandler) {
                    completionHandler(netCalories, error);
                }
            });
        });
    });
}
