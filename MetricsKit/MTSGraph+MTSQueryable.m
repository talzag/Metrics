//
//  MTSGraph+MTSQueryable.m
//  Metrics
//
//  Created by Daniel Strokis on 4/2/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraph.h"
#import "MTSQuery.h"

NSString * const _Nonnull MTSGraphLineColorKey = @"com.dstrokis.Mtrcs.lineColor";
NSString * const _Nonnull MTSGraphDataPointsKey = @"com.dstrokis.Mtrcs.data";
NSString * const _Nonnull MTSGraphDataIdentifierKey = @"com.dstrokis.Mtrcs.data-identifier";

@implementation MTSGraph (MTSQueryable)

- (void)executeQueryUsingHealthStore:(HKHealthStore * _Nonnull)healthStore withCompletionHandler:(void (^ _Nullable)(NSArray * _Nullable, NSError * _Nullable))completionHandler {
    if (![self query]) {
        return;
    }
    
    // Create an NSSet of HKQuantityType*
    NSSet *identifiers = [[self query] quantityTypes];
    NSMutableArray <HKQuantityType *>*types = [NSMutableArray array];
    for (HKQuantityTypeIdentifier identifier in identifiers) {
        HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:identifier];
        [types addObject:type];
    }
    
    // Use NSSet to get preferred units
    // using GCD to make this work synchronous on our current thread.
    __block NSDictionary *units;
    __block NSError *unitError;
    dispatch_semaphore_t unitSema = dispatch_semaphore_create(0);
    [healthStore preferredUnitsForQuantityTypes:[NSSet setWithArray:types]
                                     completion:^(NSDictionary<HKQuantityType *,HKUnit *> * _Nonnull preferredUnits, NSError * _Nullable error) {
                                         if (error) {
                                             unitError = error;
                                         } else {
                                             units = preferredUnits;
                                         }
                                         
                                         dispatch_semaphore_signal(unitSema);
                                     }];
    dispatch_semaphore_wait(unitSema, DISPATCH_TIME_FOREVER);
    
    if (unitError) {
        completionHandler(nil, unitError);
        return;
    }
    
    // Create handler for each HKSampleQuery*
    dispatch_group_t group = dispatch_group_create();
    // Query error check happens at end after all queries have been executed.
    __block NSError *queryError;
    NSMutableArray *finishedArray = [NSMutableArray array];
    void (^resultsHandler)(HKSampleQuery*, NSArray*, NSError*) = ^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        if (error) {
            //FIXME: combine NSError's instead
            queryError = error;
        } else {
            [finishedArray addObjectsFromArray:results];
        }
        
        dispatch_group_leave(group);
    };
    
    // Iterate over NSSet of HKQuantityType* to create HKSampleQuery*
    // execute those queries
    NSDate *start = [[self query] startDate];
    NSDate *end = [[self query] endDate];
    NSPredicate *predicate = [HKSampleQuery predicateForSamplesWithStartDate:start
                                                                     endDate:end
                                                                     options:HKQueryOptionNone];
    for (HKQuantityType *type in types) {
        HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:type
                                                               predicate:predicate
                                                                   limit:HKObjectQueryNoLimit
                                                         sortDescriptors:nil
                                                          resultsHandler:resultsHandler];
        dispatch_group_enter(group);
        [healthStore executeQuery:query];
    }
    
    // Wait until all HKQuery's have been executed
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    
    // Finally, call the completion handler
    if (queryError) {
        completionHandler(nil, queryError);
    } else {
        completionHandler(finishedArray, NULL);
    }
}

@end
