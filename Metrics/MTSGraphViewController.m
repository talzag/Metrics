//
//  MTSGraphViewController.m
//  Metrics
//
//  Created by Daniel Strokis on 2/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphViewController.h"

@interface MTSGraphViewController ()

@end

@implementation MTSGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark HealthKit

- (void)queryHealthStore:(HKHealthStore * _Nonnull)healthStore
         forQuantityType:(HKQuantityTypeIdentifier _Nonnull)typeIdentifier
                fromDate:(NSDate * _Nonnull)startDate
                  toDate:(NSDate * _Nonnull)endDate
  usingCompletionHandler:(void (^)(NSArray <HKSample *>*samples)) completionHandler {
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

    [self.healthStore executeQuery:query];
}


@end
