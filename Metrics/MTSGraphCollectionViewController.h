//
//  GraphCollectionViewController.h
//  Metrics
//
//  Created by Daniel Strokis on 2/5/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <UIKit/UIKit.h>

@import HealthKit;

@interface MTSGraphCollectionViewController : UICollectionViewController

@property (strong) HKHealthStore *healthStore;

@end
