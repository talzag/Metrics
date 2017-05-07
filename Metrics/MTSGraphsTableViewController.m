//
//  MTSGraphsTableViewController.m
//  Metrics
//
//  Created by Daniel Strokis on 5/2/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphsTableViewController.h"
#import "MTSGraphViewController.h"
#import "MTSGraphCreationViewController.h"
#import "MTSDataSelectionViewController.h"
#import "MTSGraphTableViewCell.h"

@interface MTSGraphsTableViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController <MTSGraph *>*fetchedResultsController;

@end

@implementation MTSGraphsTableViewController

static NSString * const cellIdentifier = @"GraphCell";

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

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [[self tableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = [self tableView];
    
    switch (type) {
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [[self tableView] endUpdates];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showGraph"]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [[self tableView] indexPathForCell:cell];
        MTSGraph *graph = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        MTSGraphViewController *destination = (MTSGraphViewController *)[segue destinationViewController];
        [destination setGraph:graph];
        [destination setHealthStore:[self healthStore]];
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
    
    NSArray *visible = [[self tableView] indexPathsForVisibleRows];
    [[self tableView] reloadRowsAtIndexPaths:visible withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> resultsSection = [[[self fetchedResultsController] sections] objectAtIndex:section];
    return [resultsSection numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MTSGraphTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    MTSGraph *graph = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    [graph executeQueryWithHealthStore:[self healthStore]
                usingCompletionHandler:^(NSArray * _Nullable results, NSError * _Nullable error) {
                    if (error) {
                        return;
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[cell graphView] setDataPoints:results];
                    });
                }];
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MTSGraph *graph = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[self managedObjectContext] deleteObject:graph];
    }
}

@end
