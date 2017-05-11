//
//  MTSGraph+MTSQueryable.m
//  Metrics
//
//  Created by Daniel Strokis on 4/2/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraph.h"
#import "MTSQuery.h"
#import "MTSGraphDrawing.h"

@implementation MTSGraph (MTSQueryable)

- (void)executeQueriesWithHealthStore:(HKHealthStore * _Nonnull)healthStore usingCompletionHandler:(void (^ _Nullable)(NSError * _Nullable))completionHandler {
    if (![self queries] || ![[self queries] count]) {
        NSError *error = [NSError errorWithDomain:@"com.dstrokis.Metrics"
                                             code:1
                                         userInfo:@{ NSLocalizedDescriptionKey: @"Query cannot be nil" }];
        completionHandler(error);
        return;
    }
    
    if (!healthStore) {
        NSError *error = [NSError errorWithDomain:@"com.dstrokis.Metrics"
                                             code:2
                                         userInfo:@{ NSLocalizedDescriptionKey: @"Health store cannot be nil" }];
        completionHandler(error);
        return;
    }

    NSSet <MTSQuery *> *queries = [self queries];
    
    NSMutableArray <HKQuantityType *>*types = [NSMutableArray array];
    for (MTSQuery *query in queries) {
        HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:[query healthKitTypeIdentifier]];
        [types addObject:type];
    }
    
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    dispatch_group_t queriesGroup = dispatch_group_create();
    
    [healthStore preferredUnitsForQuantityTypes:[NSSet setWithArray:types] completion:
     ^(NSDictionary<HKQuantityType *,HKUnit *> * _Nonnull preferredUnits, NSError * _Nullable error)
     {
         dispatch_async(backgroundQueue, ^
         {
             for (MTSQuery *graphQuery in queries)
             {
                 NSDate *start = [self startDate];
                 NSDate *end = [self endDate];
                 NSPredicate *predicate = [HKSampleQuery predicateForSamplesWithStartDate:start
                                                                                  endDate:end
                                                                                  options:HKQueryOptionNone];

                 HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:[graphQuery healthKitTypeIdentifier]];
                 HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:type predicate:predicate limit:HKObjectQueryNoLimit sortDescriptors:nil resultsHandler:
                 ^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error)
                 {
                     NSMutableArray *fetchedDataPoints = [NSMutableArray array];
                     
                     for (HKQuantitySample *sample in results)
                     {
                         HKQuantityType *type = [sample quantityType];
                         HKUnit *unit = [preferredUnits objectForKey:type];
                         
                         double quantity = [[sample quantity] doubleValueForUnit:unit];
                         NSNumber *amount = [NSNumber numberWithDouble:quantity];
                         [fetchedDataPoints addObject:amount];
                     }
                     
                     [graphQuery setFetchedDataPoints:fetchedDataPoints];
                     dispatch_group_leave(queriesGroup);
                 }];
                 
                 dispatch_group_enter(queriesGroup);
                 [healthStore executeQuery:query];
             }
             
             dispatch_group_wait(queriesGroup, DISPATCH_TIME_FOREVER);
             completionHandler(nil);
         });
     }];
}

@end
