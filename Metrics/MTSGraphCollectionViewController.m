//
//  GraphCollectionViewController.m
//  Metrics
//
//  Created by Daniel Strokis on 2/5/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphCollectionViewController.h"
#import "MTSGraphCollectionViewCell.h"
#import "MTSGraph.h"

@interface MTSGraphCollectionViewController ()

@property (strong) NSArray <MTSGraph *>*graphs;

@end

@implementation MTSGraphCollectionViewController

static NSString * const reuseIdentifier = @"GraphCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MTSGraph *graph = [MTSGraph new];
    graph.title = @"Test graph";
    graph.xAxisTitle = @"X Axis";
    graph.yAxisTitle = @"Y Axis";
    graph.dataPoints = @{
                         MTSGraphLineColorKey: [UIColor whiteColor],
                         MTSGraphDataPointsKey: [NSArray arrayWithObjects: @25, @50, @75, @100, @50, @63, @42, nil]
                         };
    self.graphs = [NSArray arrayWithObject:graph];
}

#pragma mark - Navigation

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.graphs count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTSGraphCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    MTSGraph *graph = [self.graphs objectAtIndex:[indexPath row]];
    cell.graphView.titleLabel.text = graph.title;
    cell.graphView.xAxisTitle = graph.xAxisTitle;
    cell.graphView.yAxisTitle = graph.yAxisTitle;
    cell.graphView.dataPoints = @[graph.dataPoints];
    cell.graphView.topColor = [UIColor orangeColor];
    cell.graphView.bottomColor = [UIColor redColor];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

//#pragma mark HealthKit
//
//- (void)queryHealthStore:(HKHealthStore * _Nonnull)healthStore
//         forQuantityType:(HKQuantityTypeIdentifier _Nonnull)typeIdentifier
//                fromDate:(NSDate * _Nonnull)startDate
//                  toDate:(NSDate * _Nonnull)endDate
//  usingCompletionHandler:(void (^)(NSArray <HKSample *>*samples)) completionHandler {
//    NSPredicate *predicate = [HKSampleQuery predicateForSamplesWithStartDate:startDate
//                                                                     endDate:endDate
//                                                                     options:HKQueryOptionStrictEndDate];
//
//    HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:typeIdentifier];
//
//    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:sampleType
//                                                           predicate:predicate
//                                                               limit:HKObjectQueryNoLimit
//                                                     sortDescriptors:nil
//                                                      resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
//                                                          if (!results) {
//                                                              NSLog(@"Error executing query: %@", error.localizedDescription);
//                                                              return;
//                                                          }
//
//                                                          NSLog(@"Number of samples: %lu", [results count]);
//                                                          completionHandler(results);
//                                                      }];
//
//    [self.healthStore executeQuery:query];
//}


@end
