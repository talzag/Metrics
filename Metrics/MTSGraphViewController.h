//
//  MTSGraphViewController.h
//  Metrics
//
//  Created by Daniel Strokis on 2/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import UIKit;
@import HealthKit;

#import <MetricsKit/MetricsKit.h>
#import "MTSGraphView.h"

@interface MTSGraphViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) HKHealthStore *healthStore;
@property (nonatomic) MTSGraph *graph;
@property (weak, nonatomic) IBOutlet MTSGraphView *graphView;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UITableView *healthTypesTableView;

@end
