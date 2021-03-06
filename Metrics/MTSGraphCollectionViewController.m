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
        MTSGraphCollectionViewCell *cell = (MTSGraphCollectionViewCell *)sender;
        NSIndexPath *indexPath = [[self collectionView] indexPathForCell:cell];
        MTSGraph *graph =[[self graphs] objectAtIndex:[indexPath row]];
        
        MTSGraphViewController *destination = (MTSGraphViewController *)[segue destinationViewController];
        [destination setGraph:graph];
    } else if ([segue.identifier isEqualToString:@"Create Graph"]) {
        MTSGraph *graph = [[MTSGraph alloc] initWithContext:[self managedObjectContext]];
        
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        MTSGraphCreationViewController *destination = [[navController viewControllers] firstObject];
        [destination setGraph:graph];
    }
}

- (IBAction)exitFromGraphCreationScene:(UIStoryboardSegue *)segue {
    MTSGraphCreationViewController *source = (MTSGraphCreationViewController *)[segue sourceViewController];
    MTSGraph *graph = [source graph];
    self.graphs = [[self graphs] arrayByAddingObject:graph];
    
    [[self collectionView] reloadData];
        
    if (![[self managedObjectContext] hasChanges]) {
        return;
    }
    
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"%@", [error debugDescription]);
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self graphs] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTSGraphCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    MTSGraph *graph = [self.graphs objectAtIndex:[indexPath row]];
    [[cell graphTitleLabel] setText:[graph title]];
    
    MTSGraphView *graphView = [cell graphView];
    [cell setGraphView:graphView];
    
    return cell;
}

@end
