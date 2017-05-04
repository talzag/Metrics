//
//  MTSHealthDataCoordinator.m
//  Metrics
//
//  Created by Daniel Strokis on 3/15/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSHealthStoreManager.h"
#import "MTSQuantityTypeIdentifiers.h"

@implementation MTSHealthStoreManager

+ (void)requestReadAccessForHealthStore:(HKHealthStore *)healthStore
                      completionHandler:(void (^ _Nonnull)(BOOL, NSError * _Nullable))completionHandler {
    NSMutableSet *readTypes = [NSMutableSet set];
    
    NSDictionary <HKQuantityTypeIdentifier, NSString *> *identifiers = MTSQuantityTypeIdentifiers();
    [identifiers enumerateKeysAndObjectsUsingBlock:^(HKQuantityTypeIdentifier _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [readTypes addObject:[HKObjectType quantityTypeForIdentifier:key]];
    }];
    
    [healthStore requestAuthorizationToShareTypes:nil readTypes:readTypes completion:^(BOOL success, NSError * _Nullable error) {
        completionHandler(success, error);
    }];
}

+ (void)queryHealthStore:(nonnull HKHealthStore *)healthStore
         forQuantityType:(nonnull HKQuantityTypeIdentifier)typeIdentifier
                fromDate:(nonnull NSDate *)startDate
                  toDate:(nonnull NSDate *)endDate
  usingCompletionHandler:(void (^ _Nonnull)(NSArray * _Nullable samples)) completionHandler {
    NSPredicate *predicate = [HKSampleQuery predicateForSamplesWithStartDate:startDate
                                                                     endDate:endDate
                                                                     options:HKQueryOptionStrictEndDate];
    
    HKQuantityType *sampleType = [HKSampleType quantityTypeForIdentifier:typeIdentifier];
    
    void (^queryCompletion)(HKSampleQuery *, NSArray *, NSError *) = ^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        if (!results) {
            NSLog(@"Error executing query: %@", error.localizedDescription);
            return;
        }
        
        [healthStore preferredUnitsForQuantityTypes:[NSSet setWithObject:sampleType]
                                         completion:^(NSDictionary<HKQuantityType *,HKUnit *> * _Nonnull preferredUnits, NSError * _Nullable error)
         {
             if (!preferredUnits) {
                 return;
             }
             
             HKUnit *preferredUnit = [preferredUnits objectForKey:sampleType];
             
             NSMutableArray *samples = [NSMutableArray array];
             for (HKQuantitySample *sample in results) {
                 NSDate *date = [sample endDate];
                 NSString *unitString = [preferredUnit unitString];
                 double value = [[sample quantity] doubleValueForUnit:preferredUnit];
                 NSNumber *amount = [NSNumber numberWithDouble:value];
                 
                 NSDictionary *mtsSample = @{
                                             @"date": date,
                                             @"unit": unitString,
                                             @"amount": amount
                                             };
                 
                 [samples addObject:mtsSample];
             }
             
             completionHandler(samples);
         }];
    };
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:sampleType
                                                           predicate:predicate
                                                               limit:HKObjectQueryNoLimit
                                                     sortDescriptors:nil
                                                      resultsHandler:queryCompletion];
    
    [healthStore executeQuery:query];
}

@end
