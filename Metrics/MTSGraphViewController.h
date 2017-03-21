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

@interface MTSGraphViewController : UIViewController

@property MTSGraph *graph;
@property (weak, nonatomic) IBOutlet MTSGraphView *graphView;

@end
