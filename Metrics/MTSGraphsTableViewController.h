//
//  MTSGraphsTableViewController.h
//  Metrics
//
//  Created by Daniel Strokis on 5/2/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import UIKit;
@import HealthKit;
@import CoreData;

#import <MetricsKit/MetricsKit.h>

@interface MTSGraphsTableViewController : UITableViewController

@property HKHealthStore *healthStore;
@property NSManagedObjectContext *managedObjectContext;

@end
