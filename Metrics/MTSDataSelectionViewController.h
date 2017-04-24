//
//  MTSDataSelectionViewController.h
//  Metrics
//
//  Created by Daniel Strokis on 4/23/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import UIKit;
@import HealthKit;

#import <MetricsKit/MetricsKit.h>

@interface MTSDataSelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) MTSGraph *graph;

@end
