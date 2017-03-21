//
//  MTSGraphCreationViewController.h
//  Metrics
//
//  Created by Daniel Strokis on 2/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import UIKit;

#import <MetricsKit/MetricsKit.h>

@import HealthKit;

@interface MTSGraphCreationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *graphTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *startDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *endDateTextField;

@property MTSGraph *graph;

@end
