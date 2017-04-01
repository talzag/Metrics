//
//  MTSGraph+HKQuery.m
//  Metrics
//
//  Created by Daniel Strokis on 2/26/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraph+HKQuery.h"
#import "MTSGraphView.h"
#import "MTSHealthStoreManager.h"

//@implementation MTSGraph (HKQuery)
//
//- (void)populateDataPointsByQueryingHealthStore:(HKHealthStore * _Nonnull)healthStore
//                             completionHandler:(void (^ _Nullable)(NSArray<__kindof HKSample *> * _Nullable samples))completionHandler {
//    for (id ident in self.quantityHealthTypeIdentifiers) {
//        __weak MTSGraph *weakSelf = self;
//        if ([ident isKindOfClass:[NSString class]]) {
//            [MTSHealthDataCoordinator queryHealthStore:healthStore
//                                       forQuantityType:(HKQuantityTypeIdentifier)ident
//                                              fromDate:self.startDate
//                                                toDate:self.endDate
//                                usingCompletionHandler:^(NSArray<__kindof HKSample *> * _Nullable samples) {
//                                    NSMutableArray *dataPoints = [NSMutableArray array];
//                                    for (HKQuantitySample *sample in samples) {
//                                        double calories = [sample.quantity doubleValueForUnit:[HKUnit kilocalorieUnit]];
//                                        [dataPoints addObject:[NSNumber numberWithDouble:calories]];
//                                    }
//                                    
//                                    NSDictionary *graphLine = @{
//                                                                MTSGraphLineColorKey: [UIColor blueColor],
//                                                                MTSGraphDataPointsKey: [NSArray arrayWithArray:dataPoints],
//                                                                MTSGraphDataIdentifierKey: samples.firstObject.sampleType.identifier
//                                                                };
//                                    
//                                    MTSGraph *this = weakSelf;
//                                    this.dataPoints = [NSSet setWithObject:graphLine];
//                                    
//                                    NSError *error;
//                                    if (![this.managedObjectContext save:&error]) {
//                                        NSLog(@"Error saving: %@", error.debugDescription);
//                                    }
//                                    
//                                    if (completionHandler) {
//                                        completionHandler(samples);
//                                    }
//                                }];
//        }
//    }
//}
//
//@end
