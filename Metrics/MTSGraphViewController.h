//
//  MTSGraphViewController.h
//  Metrics
//
//  Created by Daniel Strokis on 2/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTSGraphView.h"
#import "MTSGraph+CoreDataClass.h"
@import HealthKit;

@interface MTSGraphViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property HKHealthStore *healthStore;
@property MTSGraph *graph;
@property (weak, nonatomic) IBOutlet MTSGraphView *graphView;
@property NSDictionary <NSString *, HKQuantityTypeIdentifier>*quantityTypeIdentifiers;

@end
