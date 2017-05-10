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

- (void)executeQueryWithHealthStore:(HKHealthStore * _Nonnull)healthStore usingCompletionHandler:(void (^ _Nullable)(NSError * _Nullable))completionHandler {
    if (![self query]) {
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

    NSDate *start = [[self query] startDate];
    NSDate *end = [[self query] endDate];
    NSPredicate *predicate = [HKSampleQuery predicateForSamplesWithStartDate:start
                                                                     endDate:end
                                                                     options:HKQueryOptionNone];
    
    NSSet <MTSQueryDataConfiguration *>*dataConfigurations = [[self query] dataTypeConfigurations];
    
    NSMutableArray <HKQuantityType *>*types = [NSMutableArray array];
    for (MTSQueryDataConfiguration *config in dataConfigurations) {
        HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:[config healthKitTypeIdentifier]];
        [types addObject:type];
    }
    
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    dispatch_group_t queriesGroup = dispatch_group_create();
    
    [healthStore preferredUnitsForQuantityTypes:[NSSet setWithArray:types] completion:
     ^(NSDictionary<HKQuantityType *,HKUnit *> * _Nonnull preferredUnits, NSError * _Nullable error)
     {
         dispatch_async(backgroundQueue, ^{
             for (HKQuantityType *type in types)
             {
                 HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:type predicate:predicate limit:HKObjectQueryNoLimit sortDescriptors:nil resultsHandler:
                 ^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error)
                 {
                     NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.healthKitTypeIdentifier == %@", [[query objectType] identifier]];
                     MTSQueryDataConfiguration *dataConfig = [[dataConfigurations filteredSetUsingPredicate:pred] anyObject];
                     
                     NSMutableArray *fetchedDataPoints = [NSMutableArray array];
                     
                     for (HKQuantitySample *sample in results)
                     {
                         HKQuantityType *type = [sample quantityType];
                         HKUnit *unit = [preferredUnits objectForKey:type];
                         
                         double quantity = [[sample quantity] doubleValueForUnit:unit];
                         NSNumber *amount = [NSNumber numberWithDouble:quantity];
                         [fetchedDataPoints addObject:amount];
                     }
                     
                     [dataConfig setFetchedDataPoints:[NSArray arrayWithArray:fetchedDataPoints]];
                     dispatch_group_leave(queriesGroup);
                 }];
                 
                 dispatch_group_enter(queriesGroup);
                 [healthStore executeQuery:query];
             }
             
             dispatch_group_wait(queriesGroup, DISPATCH_TIME_FOREVER);
             NSLog(@"Finished executing health store queries");
             completionHandler(nil);
         });
     }];
}

@end
