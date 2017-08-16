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

@property (nonatomic, nonnull) HKHealthStore * healthStore;
@property (nonatomic, nonnull) MTSGraph * graph;
@property (weak, nonatomic, nullable) IBOutlet MTSGraphView *graphView;
@property (weak, nonatomic, nullable) IBOutlet UILabel * startDateLabel;
@property (weak, nonatomic, nullable) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic, nullable) IBOutlet UITableView *healthTypesTableView;

@property (nullable, nonatomic, readwrite, strong) __kindof UIView *inputView;

@end
