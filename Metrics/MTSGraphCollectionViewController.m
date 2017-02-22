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
#import "MTSGraphCreationViewController.h"
#import "MTSGraph+CoreDataProperties.h"

@interface MTSGraphCollectionViewController ()

@property (strong) NSArray <MTSGraph *>*graphs;

@end

@implementation MTSGraphCollectionViewController

static NSString * const reuseIdentifier = @"GraphCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSFetchRequest *request = [MTSGraph fetchRequest];
    NSError *error;
    NSArray *graphs = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (graphs == nil) {
        NSLog(@"Error fetching graphs: %@", error.localizedDescription);
    }
    
    self.graphs = graphs;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Show Graph"]) {
        MTSGraphViewController *destination = (MTSGraphViewController *)[segue destinationViewController];
        destination.navigationItem.title = ((MTSGraphCollectionViewCell *) sender).graphView.titleLabel.text;
    } else if ([segue.identifier isEqualToString:@"Create Graph"]) {
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        MTSGraphCreationViewController *destination = (MTSGraphCreationViewController *)navController.viewControllers.firstObject;
        destination.quantityTypeIdentifiers = self.quantityTypeIdentifiers;
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
    cell.graphView.dataPoints = graph.dataPoints;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

@end
