//
//  AppDelegate.h
//  Metrics
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import UIKit;
@import HealthKit;
@import CoreData;

#import <MetricsKit/MetricsKit.h>
#import "MTSGraphsTableViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (strong) HKHealthStore *healthStore;

- (void)saveContext;

@end

