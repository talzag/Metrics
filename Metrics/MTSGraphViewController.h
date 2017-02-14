//
//  MTSGraphViewController.h
//  Metrics
//
//  Created by Daniel Strokis on 2/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTSGraphView.h"
@import HealthKit;

@interface MTSGraphViewController : UIViewController

@property HKHealthStore *healthStore;
@property (weak, nonatomic) IBOutlet MTSGraphView *graphView;

@end
