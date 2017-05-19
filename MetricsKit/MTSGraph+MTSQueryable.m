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
    // Dates might be null early in the graph creation process
    if (![self startDate] || ![self endDate]) {
        return;
    }
    
    if (![self queries] || ![[self queries] count]) {
        NSError *error = [NSError errorWithDomain:@"com.dstrokis.Metrics"
                                             code:1
                                         userInfo:@{ NSLocalizedDescriptionKey: @"Queries cannot be nil" }];
        if (completionHandler) {
            completionHandler(error);
        }
        
        return;
    }
    
    if (!healthStore) {
        NSError *error = [NSError errorWithDomain:@"com.dstrokis.Metrics"
                                             code:2
                                         userInfo:@{ NSLocalizedDescriptionKey: @"Health store cannot be nil" }];
        if (completionHandler) {
            completionHandler(error);
        }
        
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
                                                                                  options:HKQueryOptionStrictStartDate | HKQueryOptionStrictEndDate];
                 
                 HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:[graphQuery healthKitTypeIdentifier]];
                 
                 // TODO: Make interval adjustable based on query/view
                 NSDateComponents *components = [NSDateComponents new];
                 [components setDay:1];

                 NSCalendar *calendar = [NSCalendar currentCalendar];
                 NSDateComponents *anchorComponents = [calendar components:NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay
                                                                  fromDate:start];
                 NSDate *anchorDate = [calendar dateFromComponents:anchorComponents];
                 
                 HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:type
                                                                                        quantitySamplePredicate:predicate
                                                                                                        options:HKStatisticsOptionCumulativeSum
                                                                                                     anchorDate:anchorDate
                                                                                             intervalComponents:components];
                 
                 void(^initialResultsHandler)(HKStatisticsCollectionQuery *, HKStatisticsCollection *, NSError *);
                 initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error) {
                     NSMutableArray *fetchedDataPoints = [NSMutableArray array];
                     
                     [results enumerateStatisticsFromDate:start toDate:end withBlock:^(HKStatistics * _Nonnull result, BOOL * _Nonnull stop) {
                         HKQuantity *sum = [result sumQuantity];
                         
                         HKQuantityType *type = [result quantityType];
                         HKUnit *unit = [preferredUnits objectForKey:type];
                         double quantity = [sum doubleValueForUnit:unit];
                         NSNumber *amount = [NSNumber numberWithDouble:quantity];
                         
                         [fetchedDataPoints addObject:amount];
                     }];
                     
                     [graphQuery setFetchedDataPoints:fetchedDataPoints];
                     
                     dispatch_group_leave(queriesGroup);
                 };
                 
                 dispatch_group_enter(queriesGroup);
                 
                 [query setInitialResultsHandler:initialResultsHandler];
                 [healthStore executeQuery:query];
             }
             
             dispatch_group_wait(queriesGroup, DISPATCH_TIME_FOREVER);
             
             if (completionHandler) {
                 completionHandler(nil);
             }
         });
     }];
}

@end
