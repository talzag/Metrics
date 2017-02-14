//
//  GraphCollectionViewController.m
//  Metrics
//
//  Created by Daniel Strokis on 2/5/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphCollectionViewController.h"
#import "MTSGraphCollectionViewCell.h"
#import "MTSGraphViewController.h"
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Show Graph"]) {
        MTSGraphViewController *destination = (MTSGraphViewController *)[segue destinationViewController];
        destination.navigationItem.title = ((MTSGraphCollectionViewCell *) sender).graphView.titleLabel.text;
    }
}

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
    cell.graphView.dataPoints = @[@{
                                      MTSGraphLineColorKey: [UIColor whiteColor],
                                      MTSGraphDataPointsKey: [NSArray arrayWithObjects: @25, @50, @75, @100, @50, @63, @42, nil]
                                  },@{
                                      MTSGraphLineColorKey: [UIColor greenColor],
                                      MTSGraphDataPointsKey: [NSArray arrayWithObjects: @12, @85, @37, @2, @74, @3, @78, nil]
                                  }]
    ;
    cell.graphView.topColor = [UIColor orangeColor];
    cell.graphView.bottomColor = [UIColor redColor];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

@end
