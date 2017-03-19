//
//  MTSHealthDataCoordinator.m
//  Metrics
//
//  Created by Daniel Strokis on 3/15/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSHealthDataCoordinator.h"
#import "MTSQuantityTypeIdentifiers.h"

@implementation MTSHealthDataCoordinator

+ (BOOL)healthType:(HKQuantityTypeIdentifier)typeA canBeGroupedWithHealthType:(HKQuantityTypeIdentifier)typeB {
    return (typeA == typeB) && (typeA == HKQuantityTypeIdentifierBasalEnergyBurned  ||
                                typeA == HKQuantityTypeIdentifierActiveEnergyBurned ||
                                typeA == HKQuantityTypeIdentifierDietaryEnergyConsumed);
}

+ (void)queryHealthStore:(HKHealthStore * _Nonnull)healthStore
         forQuantityType:(HKQuantityTypeIdentifier _Nonnull)typeIdentifier
                fromDate:(NSDate * _Nonnull)startDate
                  toDate:(NSDate * _Nonnull)endDate
  usingCompletionHandler:(void (^ _Nonnull)(NSArray <__kindof HKSample *>* _Nullable samples)) completionHandler {
    NSPredicate *predicate = [HKSampleQuery predicateForSamplesWithStartDate:startDate
                                                                     endDate:endDate
                                                                     options:HKQueryOptionNone];
    
    HKQuantityType *sampleType = [HKSampleType quantityTypeForIdentifier:typeIdentifier];
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:sampleType
                                                           predicate:predicate
                                                               limit:HKObjectQueryNoLimit
                                                     sortDescriptors:nil
                                                      resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
                                                          if (!results) {
                                                              NSLog(@"Error executing query: %@", error.localizedDescription);
                                                              return;
                                                          }
                                                          
                                                          completionHandler(results);
                                                      }];
    
    [healthStore executeQuery:query];

}

@end
