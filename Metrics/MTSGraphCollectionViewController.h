//
//  GraphCollectionViewController.h
//  Metrics
//
//  Created by Daniel Strokis on 2/5/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import UIKit;

#import <MetricsKit/MetricsKit.h>

@import HealthKit;
@import CoreData;

@interface MTSGraphCollectionViewController : UICollectionViewController

@property HKHealthStore *healthStore;
@property NSManagedObjectContext *managedObjectContext;

@end
