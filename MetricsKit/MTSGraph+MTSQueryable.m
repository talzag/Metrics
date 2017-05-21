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

- (void)executeQueriesWithHealthStore:(HKHealthStore * _Nonnull)healthStore
               usingCompletionHandler:(void (^ _Nullable)(NSError * _Nullable))completionHandler {
   
    // Dates might be null early in the graph creation process
    if (![self startDate] || ![self endDate]) {
        return;
    }
    
    // Call completion handler with error if queries are nil
    if (![self queries] || ![[self queries] count]) {
        NSError *error = [NSError errorWithDomain:@"com.dstrokis.Metrics"
                                             code:1
                                         userInfo:@{ NSLocalizedDescriptionKey: @"Queries cannot be nil" }];
        if (completionHandler) {
            completionHandler(error);
        }
        
        return;
    }
    
    // Call completion handler with error if healthStore is nil
    if (!healthStore) {
        NSError *error = [NSError errorWithDomain:@"com.dstrokis.Metrics"
                                             code:2
                                         userInfo:@{ NSLocalizedDescriptionKey: @"Health store cannot be nil" }];
        if (completionHandler) {
            completionHandler(error);
        }
        
        return;
    }

    
    // Create predicate for the HKStatisticsCollectionQuery
    NSDate *start = [self startDate];
    NSDate *end = [self endDate];
    NSPredicate *predicate = [HKSampleQuery predicateForSamplesWithStartDate:start
                                                                     endDate:end
                                                                     options:HKQueryOptionStrictStartDate | HKQueryOptionStrictEndDate];
    
    // TODO: Make interval adjustable based on query/view
    
    // Create the interval components of the HKStatisticsCollectionQuery
    NSDateComponents *components = [NSDateComponents new];
    [components setDay:1];

    // Create the anchor date for the HKStatisticsCollectionQuery
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *anchorComponents = [calendar components:NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay
                                                     fromDate:start];
    NSDate *anchorDate = [calendar dateFromComponents:anchorComponents];
    
    // Grab reference to graph.queries
    NSSet <MTSQuery *> *queries = [self queries];
    
    // Create NSSet of HKQuantityTypes (to get preferred units
    NSMutableArray <HKQuantityType *>*queryTypes = [NSMutableArray array];
    for (MTSQuery *query in queries) {
        HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:[query healthKitTypeIdentifier]];
        [queryTypes addObject:type];
    }
    NSSet *types = [NSSet setWithArray:queryTypes];
    
    // Create background queue to execute these queries on
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    
    // Create dispatch group to block queue until all queries have executed
    dispatch_group_t queriesGroup = dispatch_group_create();
    
    // Get preferred units for every HKQuantityType being queried
    [healthStore preferredUnitsForQuantityTypes:types completion: ^(NSDictionary<HKQuantityType *,HKUnit *> * _Nonnull preferredUnits, NSError * _Nullable error) {
        dispatch_async(backgroundQueue, ^ {
            // Iterate over graph queries
            for (MTSQuery *graphQuery in queries) {
                
                // Get HKQuantityType of the query
                HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:[graphQuery healthKitTypeIdentifier]];
                
                // Get the user's preferred HKUnit for the type
                HKUnit *unit = [preferredUnits objectForKey:type];

                // Determine statistics options based on type aggregation style
                HKStatisticsOptions options;
                if ([type aggregationStyle] == HKQuantityAggregationStyleDiscrete) {
                 options = HKStatisticsOptionDiscreteAverage;
                } else {
                 options = HKStatisticsOptionCumulativeSum;
                }
                
                // Create HKStatisticsCollectionQuery
                HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:type quantitySamplePredicate:predicate options:options anchorDate:anchorDate intervalComponents:components];

                [query setInitialResultsHandler:^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error) {
                    // Upon the HKStatisticsCollectionQuery completion, populate the fetchedDataPoints array of the MTSQuery
                    
                    NSMutableArray *fetchedDataPoints = [NSMutableArray array];
                    
                    [results enumerateStatisticsFromDate:start toDate:end withBlock:^(HKStatistics * _Nonnull result, BOOL * _Nonnull stop) {
                        HKQuantity *total;

                        if (options == HKStatisticsOptionDiscreteAverage) {
                            total = [result averageQuantity];
                        } else {
                            total = [result sumQuantity];
                        }

                        double quantity = [total doubleValueForUnit:unit];
                        NSNumber *amount = [NSNumber numberWithDouble:quantity];

                        [fetchedDataPoints addObject:amount];
                    }];

                    [graphQuery setFetchedDataPoints:fetchedDataPoints];

                    // Leave the dispatch group when done
                    dispatch_group_leave(queriesGroup);
                }];
                
                // Enter the dispatch group before starting
                dispatch_group_enter(queriesGroup);

                [healthStore executeQuery:query];
             }
            
            // Wait until all queries have been executed
            dispatch_group_wait(queriesGroup, DISPATCH_TIME_FOREVER);

            // Optionally call completion handler
            if (completionHandler) {
                completionHandler(nil);
            }
        });
    }];
}

@end
