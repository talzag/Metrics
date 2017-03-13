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
#import "MTSGraph+CoreDataClass.h"

@interface MTSGraphCollectionViewController ()

@property (strong) NSArray <MTSGraph *>*graphs;

@end

@implementation MTSGraphCollectionViewController

static NSString * const reuseIdentifier = @"GraphCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSFetchRequest *request = [MTSGraph fetchRequest];
    request.fetchBatchSize = 15;
    
    NSError *error;
    NSArray *graphs = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (graphs == nil) {
        NSLog(@"Error fetching graphs: %@", error.debugDescription);
    }
    
    self.graphs = graphs;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Show Graph"]) {
        MTSGraphViewController *destination = (MTSGraphViewController *)[segue destinationViewController];
        destination.healthStore = self.healthStore;
        
        MTSGraphCollectionViewCell *cell = (MTSGraphCollectionViewCell *) sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        destination.graph = self.graphs[indexPath.row];
        
    } else if ([segue.identifier isEqualToString:@"Create Graph"]) {
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        MTSGraphCreationViewController *destination = (MTSGraphCreationViewController *)navController.viewControllers.firstObject;
        destination.quantityTypeIdentifiers = self.quantityTypeIdentifiers;
        
        MTSGraph *graph = [NSEntityDescription insertNewObjectForEntityForName:[MTSGraph entity].name
                                                        inManagedObjectContext:self.managedObjectContext];
        destination.graph = graph;
    }
}

- (IBAction)exitFromGraphCreationScene:(UIStoryboardSegue *)segue {
    MTSGraphCreationViewController *source = (MTSGraphCreationViewController *)segue.sourceViewController;
    MTSGraph *graph = source.graph;
    self.graphs = [self.graphs arrayByAddingObject:graph];
    
    [self.collectionView reloadData];
        
    if (!self.managedObjectContext.hasChanges) {
        return;
    }
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@", error.debugDescription);
    }
}

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.graphs count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTSGraphCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    MTSGraph *graph = [self.graphs objectAtIndex:[indexPath row]];
    cell.graphTitleLabel.text = graph.title;
    cell.graphView.xAxisTitle = graph.xAxisTitle;
    cell.graphView.yAxisTitle = graph.yAxisTitle;
    cell.graphView.dataPoints = graph.dataPoints;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

@end
