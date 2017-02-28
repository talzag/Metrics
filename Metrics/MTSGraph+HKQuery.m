//
//  MTSGraph+HKQuery.m
//  Metrics
//
//  Created by Daniel Strokis on 2/26/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraph+HKQuery.h"

@implementation MTSGraph (HKQuery)

- (void)populateGraphDataByQueryingHealthStore:(HKHealthStore * _Nonnull)healthStore {
    for (id ident in self.healthTypes) {
        if ([ident isKindOfClass:[NSString class]]) {
            [self queryHealthStore:healthStore forQuantityType:(HKQuantityTypeIdentifier)ident fromDate:self.startDate toDate:self.endDate usingCompletionHandler:^(NSArray<__kindof HKSample *> * _Nullable samples) {
                NSLog(@"Finished querying for %@", ident);
            }];
        }
        
    }
}

- (void)queryHealthStore:(HKHealthStore * _Nonnull)healthStore
         forQuantityType:(HKQuantityTypeIdentifier _Nonnull)typeIdentifier
                fromDate:(NSDate * _Nonnull)startDate
                  toDate:(NSDate * _Nonnull)endDate
  usingCompletionHandler:(void (^ _Nonnull)(NSArray <__kindof HKSample *>* _Nullable samples)) completionHandler {
    NSPredicate *predicate = [HKSampleQuery predicateForSamplesWithStartDate:startDate
                                                                     endDate:endDate
                                                                     options:HKQueryOptionStrictEndDate];
    
    HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:typeIdentifier];
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:sampleType
                                                           predicate:predicate
                                                               limit:HKObjectQueryNoLimit
                                                     sortDescriptors:nil
                                                      resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
                                                          if (!results) {
                                                              NSLog(@"Error executing query: %@", error.localizedDescription);
                                                              return;
                                                          }
                                                          
                                                          NSLog(@"Number of samples: %lu", [results count]);
                                                          completionHandler(results);
                                                      }];
    
    [healthStore executeQuery:query];
}


@end
