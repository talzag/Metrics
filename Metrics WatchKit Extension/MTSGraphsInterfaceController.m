//
//  MTSGraphsInterfaceController.m
//  Metrics
//
//  Created by Daniel Strokis on 3/23/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphsInterfaceController.h"
#import "ExtensionDelegate.h"
#import "MTSGraphRowController.h"

@implementation MTSGraphsInterfaceController

- (void)awakeWithContext:(id)ctx {
    [super awakeWithContext:ctx];
    
    ExtensionDelegate *delegate = (ExtensionDelegate *)[[WKExtension sharedExtension] delegate];
    NSManagedObjectContext *context = [[delegate persistentContainer] viewContext];
    [self setManagedObjectContext:context];
    [self setHealthStore:[HKHealthStore new]];
}

- (void)configureInterfaceTable {
    NSArray <MTSGraph *> *graphs = [[self  fetchedResultsController] fetchedObjects];
    
    [[self graphsInterfaceTable] setNumberOfRows:[graphs count] withRowType:@"MTSGraphRowController"];
    
    NSInteger numRows = [[self graphsInterfaceTable] numberOfRows];
    if (numRows == 0) {
        return;
    }
    
    NSInteger i;
    for (i = 0; i < numRows; i++) {
        [self configureRowControllerAtIndex:i];
    }
}

- (void)configureRowControllerAtIndex:(NSInteger)index {
    CGFloat width = CGRectGetWidth([self contentFrame]);
    CGFloat height = CGRectGetHeight([self contentFrame]) / 2.0;
    
    MTSGraph *graph = [[self fetchedResultsController] objectAtIndexPath:[NSIndexPath indexPathWithIndex:index]];
    MTSGraphRowController *controller = [[self graphsInterfaceTable] rowControllerAtIndex:index];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [graph executeQueriesWithHealthStore:[self healthStore] usingCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            MTSDrawGraph(context, CGRectMake(0, 0, width, height), graph, NO);
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            [[controller graphImage] setImage:image];
        }
    }];

}

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        NSFetchRequest *request = [MTSGraph fetchRequest];
        [request setFetchBatchSize:10];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO];
        [request setSortDescriptors:@[sortDescriptor]];
        
        NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                     managedObjectContext:[self managedObjectContext]
                                                                                       sectionNameKeyPath:nil
                                                                                                cacheName:nil];
        
        [controller setDelegate:self];
        
        NSError *error;
        BOOL success = [controller performFetch:&error];
        if (!success) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        _fetchedResultsController = controller;
    }
    
    return _fetchedResultsController;
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    NSUInteger index = [indexPath indexAtPosition:0];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [[self graphsInterfaceTable] insertRowsAtIndexes:indexSet withRowType:@"MTSGraphRowController"];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureRowControllerAtIndex:index];
            break;
        case NSFetchedResultsChangeMove:
            break;
        case NSFetchedResultsChangeDelete:
            [[self graphsInterfaceTable] removeRowsAtIndexes:indexSet];
            break;
        default:
            break;
    }
}

@end
