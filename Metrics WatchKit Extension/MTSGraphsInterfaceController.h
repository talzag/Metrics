//
//  MTSGraphsInterfaceController.h
//  Metrics
//
//  Created by Daniel Strokis on 3/23/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import Foundation;
@import WatchKit;
@import CoreData;

#import <MetricsKit/MetricsKit.h>

@interface MTSGraphsInterfaceController : WKInterfaceController <NSFetchedResultsControllerDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *graphsInterfaceTable;

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) HKHealthStore *healthStore;

@end
