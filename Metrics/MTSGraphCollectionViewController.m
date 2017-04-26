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
#import "MTSDataSelectionViewController.h"

@interface MTSGraphCollectionViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController <MTSGraph *>*fetchedResultsController;

@end

@implementation MTSGraphCollectionViewController

static NSString * const reuseIdentifier = @"GraphCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error;
    [[self fetchedResultsController] performFetch:&error];
    
    if (error) {
        NSLog(@"%@", [error description]);
    }
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        NSFetchRequest <MTSGraph *> *fetchRequest = [MTSGraph fetchRequest];
        [fetchRequest setFetchBatchSize:10];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                     managedObjectContext:[self managedObjectContext]
                                                                                       sectionNameKeyPath:nil
                                                                                                cacheName:nil];
        [controller setDelegate:self];
        _fetchedResultsController = controller;
    }
    
    return _fetchedResultsController;
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    
    UICollectionView *collectionView = [self collectionView];
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            break;
        case NSFetchedResultsChangeDelete:
            [collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            break;
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UICollectionView *collectionView = [self collectionView];
    
    switch (type) {
        case NSFetchedResultsChangeUpdate:
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            break;
        case NSFetchedResultsChangeMove:
            [collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
        case NSFetchedResultsChangeInsert:
            [collectionView insertItemsAtIndexPaths:@[newIndexPath]];
            break;
        case NSFetchedResultsChangeDelete:
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
            break;
        default:
            break;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showGraph"]) {
        MTSGraphCollectionViewCell *cell = (MTSGraphCollectionViewCell *)sender;
        NSIndexPath *indexPath = [[self collectionView] indexPathForCell:cell];
        MTSGraph *graph = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        [graph setHealthStore:[self healthStore]];
        MTSGraphViewController *destination = (MTSGraphViewController *)[segue destinationViewController];
        [destination setGraph:graph];
    } else if ([segue.identifier isEqualToString:@"selectHealthData"]) {
        MTSGraph *newGraph = [[MTSGraph alloc] initWithContext:[self managedObjectContext]];
        MTSQuery *newQuery = [[MTSQuery alloc] initWithContext:[self managedObjectContext]];
        [newGraph setQuery:newQuery];
        
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        MTSDataSelectionViewController *destination = [[navController viewControllers] firstObject];
        [destination setGraph:newGraph];
    }
}

- (IBAction)exitFromGraphCreationScene:(UIStoryboardSegue *)segue {
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"%@", [error debugDescription]);
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTSGraphCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    MTSGraph *graph = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [[cell graphTitleLabel] setText:[graph title]];
    
    MTSGraphView *graphView = [cell graphView];
    [cell setGraphView:graphView];
    
    return cell;
}

@end
