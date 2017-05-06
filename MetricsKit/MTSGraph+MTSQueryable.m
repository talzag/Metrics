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

- (void)executeQueryWithHealthStore:(HKHealthStore * _Nonnull)healthStore usingCompletionHandler:(void (^ _Nullable)(NSSet * _Nullable, NSError * _Nullable))completionHandler {
    if (![self query]) {
        NSError *error = [NSError errorWithDomain:@"com.dstrokis.Metrics"
                                             code:1
                                         userInfo:@{
                                                    NSLocalizedDescriptionKey: @"Query cannot be nil"
                                                    }];
        completionHandler(nil, error);
        return;
    }
    
    if (!healthStore) {
        NSError *error = [NSError errorWithDomain:@"com.dstrokis.Metrics"
                                             code:2
                                         userInfo:@{
                                                    NSLocalizedDescriptionKey: @"Health store cannot be nil"
                                                    }];
        completionHandler(nil, error);
        return;
    }
    
    // Create GCD group that will be used to track execution of queries
    dispatch_group_t group = dispatch_group_create();
    
    // Query error check happens at end after all queries have been executed.
    __block NSError *queryError;
    
    // Array of NSArray<__kindof HKSample *> * that will be passed to completion handler
    NSMutableArray *finishedArray = [NSMutableArray array];
    
    // Create handler for each HKSampleQuery*
    void (^resultsHandler)(HKSampleQuery*, NSArray*, NSError*) = ^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        if (error) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo addEntriesFromDictionary:[error userInfo]];
            
            NSDictionary *originalUserInfo = [queryError userInfo];
            if (originalUserInfo) {
                [userInfo addEntriesFromDictionary:originalUserInfo];
            }
            
            queryError = [NSError errorWithDomain:@"com.dstrokis.Metrics" code:3 userInfo:userInfo];
        } else {
            [finishedArray addObject:results];
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
    
    
    // Create an NSSet of HKQuantityType*
    NSSet <MTSQueryDataConfiguration *>*dataConfigurations = [[self query] dataTypeConfigurations];
    NSMutableArray <HKQuantityType *>*types = [NSMutableArray array];
    for (MTSQueryDataConfiguration *config in dataConfigurations) {
        HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:[config healthKitTypeIdentifier]];
        [types addObject:type];
    }
    
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    dispatch_async(backgroundQueue, ^{
        for (HKQuantityType *type in types) {
            HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:type
                                                                   predicate:predicate
                                                                       limit:HKObjectQueryNoLimit
                                                             sortDescriptors:nil
                                                              resultsHandler:resultsHandler];
            dispatch_group_enter(group);
            [healthStore executeQuery:query];
        }
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        
        [self graphDataFromQueryResults:finishedArray
                        withHealthStore:healthStore
                      completionHandler:^(NSSet * queryDataConfigurations, NSError * graphDataError) {
                          completionHandler(queryDataConfigurations, graphDataError);
                      }];
    });
}

- (void)graphDataFromQueryResults:(NSArray <NSArray<HKQuantitySample *> *>* _Nonnull)results
                  withHealthStore:(HKHealthStore * _Nonnull)healthStore
                completionHandler:(void (^ _Nonnull)(NSSet <MTSQueryDataConfiguration *> * _Nullable, NSError * _Nullable))completionHandler {
    NSMutableArray *types = [NSMutableArray array];
    for (NSArray <HKQuantitySample *>* sampleSet in results) {
        HKQuantitySample *sample = [sampleSet firstObject];
        if (sample) {
            HKQuantityType *type = [sample quantityType];
            [types addObject:type];
        }
    }
    
    void (^unitsHandler)(NSDictionary* _Nonnull, NSError* _Nullable) = ^(NSDictionary<HKQuantityType *,HKUnit *> * _Nonnull preferredUnits, NSError * _Nullable error) {
        if (error) {
            completionHandler(nil, error);
            return;
        }
        
        // dataTypeConfigurations should already have these properties configured before getting here:
        // - lineColor
        // - healthKitQuantityTypeIdentifier
        // - quantityTypeDisplayName
        
        for (MTSQueryDataConfiguration *dataConfig in [[self query] dataTypeConfigurations]) {
            NSMutableArray *fetchedDataPoints = [NSMutableArray array];
            
            for (NSArray <HKQuantitySample *> *sampleSet in results) {
                if (![sampleSet count]) {
                    continue;
                }
                
                HKQuantityType *type = [[sampleSet firstObject] quantityType];
                HKUnit *unit = [preferredUnits objectForKey:type];
                for (HKQuantitySample *sample in sampleSet) {
                    double quantity = [[sample quantity] doubleValueForUnit:unit];
                    NSNumber *amount = [NSNumber numberWithDouble:quantity];
                    [fetchedDataPoints addObject:amount];
                }
            }
            
            [dataConfig setFetchedDataPoints:[NSArray arrayWithArray:fetchedDataPoints]];
        }
        
//        NSMutableArray *graphDataSet = [NSMutableArray array];
//        for (NSArray <HKQuantitySample *> *sampleSet in results) {
//            if ([sampleSet count]) {
//                HKQuantityType *type = [[sampleSet firstObject] quantityType];
//                HKUnit *unit = [preferredUnits objectForKey:type];
//                
//                NSMutableArray *amounts = [NSMutableArray array];
//                
//                for (HKQuantitySample *sample in sampleSet) {
//                    double quantity = [[sample quantity] doubleValueForUnit:unit];
//                    NSNumber *amount = [NSNumber numberWithDouble:quantity];
//                    [amounts addObject:amount];
//                }
//                
//                // FIXME: Use model class here to wrap up this data instead of using a dictionary
//                NSDictionary *lineData = @{
//                                           MTSGraphDataPointsKey: amounts,
//                                           MTSGraphDataIdentifierKey: [type identifier]
//                                           };
//                [graphDataSet addObject:lineData];
//            }
//        }
        
        completionHandler([[self query] dataTypeConfigurations], nil);
    };
    
    if ([types count]) {
        [healthStore preferredUnitsForQuantityTypes:[NSSet setWithArray:types] completion:unitsHandler];
    } else {
        completionHandler([NSSet set], nil);
    }
}


@end
