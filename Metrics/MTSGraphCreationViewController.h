//
//  MTSGraphCreationViewController.h
//  Metrics
//
//  Created by Daniel Strokis on 2/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import UIKit;
@import HealthKit;
@import CoreData;

#import <MetricsKit/MetricsKit.h>

@interface MTSGraphCreationViewController : UIViewController

@property (nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSMutableSet <HKQuantityTypeIdentifier>*selectedHealthTypes;
@property (nonatomic) MTSQuery *query;
@property (nonatomic) MTSGraph *graph;

@end
