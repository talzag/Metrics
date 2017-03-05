//
//  MTSGraph+HKQuery.m
//  Metrics
//
//  Created by Daniel Strokis on 2/26/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraph+HKQuery.h"
#import "MTSGraphView.h"

@implementation MTSGraph (HKQuery)

- (void)populateGraphDataByQueryingHealthStore:(HKHealthStore * _Nonnull)healthStore {
    for (id ident in self.quantityHealthTypeIdentifiers) {
        if ([ident isKindOfClass:[NSString class]]) {
            [self queryHealthStore:healthStore
                   forQuantityType:(HKQuantityTypeIdentifier)ident
                          fromDate:self.startDate
                            toDate:self.endDate
            usingCompletionHandler:^(NSArray<__kindof HKSample *> * _Nullable samples) {
                NSLog(@"Finished querying for %@", ident);
                
                NSMutableArray *dataPoints = [NSMutableArray array];
                for (HKQuantitySample *sample in samples) {
                    double calories = [sample.quantity doubleValueForUnit:[HKUnit kilocalorieUnit]];
                    [dataPoints addObject:[NSNumber numberWithDouble:calories]];
                }
                
                NSDictionary *graphLine = @{
                                            MTSGraphLineColorKey: [UIColor blueColor],
                                            MTSGraphDataPointsKey: [NSArray arrayWithArray:dataPoints]
                                            };
                
                if (self.dataPoints) {
                    self.dataPoints = [self.dataPoints setByAddingObject:graphLine];
                } else {
                    self.dataPoints = [NSSet setWithObject:graphLine];
                }
                
                NSError *error;
                if (![self.managedObjectContext save:&error]) {
                    NSLog(@"Error saving: %@", error.debugDescription);
                }
            }];
        }
    }
    
    for (id ident in self.categoryHealthTypeIdentifiers) {
        if ([ident isKindOfClass:[NSString class]]) {
            [self queryHealthStore:healthStore
                   forCategoryType:(HKCategoryTypeIdentifier)ident
                          fromDate:self.startDate
                            toDate:self.endDate
            usingCompletionHandler:^(NSArray<__kindof HKSample *> * _Nullable samples) {
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
                                                                     options:HKQueryOptionNone];
    
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

- (void)queryHealthStore:(HKHealthStore * _Nonnull)healthStore
         forCategoryType:(HKCategoryTypeIdentifier _Nonnull)typeIdentifier
                fromDate:(NSDate * _Nonnull)startDate
                  toDate:(NSDate * _Nonnull)endDate
  usingCompletionHandler:(void (^ _Nonnull)(NSArray <__kindof HKSample *>* _Nullable samples)) completionHandler {
    NSPredicate *predicate = [HKSampleQuery predicateForSamplesWithStartDate:startDate
                                                                     endDate:endDate
                                                                     options:HKQueryOptionNone];
    
    HKCategoryType *sampleType = [HKSampleType categoryTypeForIdentifier:typeIdentifier];
    
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
