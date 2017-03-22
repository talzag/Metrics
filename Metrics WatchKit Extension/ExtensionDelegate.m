//
//  ExtensionDelegate.m
//  Metrics WatchKit Extension
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "ExtensionDelegate.h"
#import "InterfaceController.h"

@implementation ExtensionDelegate

- (void)applicationDidFinishLaunching {
    // Perform any final initialization of your application.
    
    
    if ([HKHealthStore isHealthDataAvailable]) {
        HKHealthStore *healthStore = [HKHealthStore new];
        
        [MTSHealthDataCoordinator requestReadAccessForHealthStore:healthStore completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                InterfaceController *controller = (InterfaceController *)[[WKExtension sharedExtension] rootInterfaceController];
                [controller setHealthStore:healthStore];
            }
        }];
    }
}

- (void)applicationDidBecomeActive {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillResignActive {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, etc.
}

- (void)handleBackgroundTasks:(NSSet<WKRefreshBackgroundTask *> *)backgroundTasks {
    for (WKRefreshBackgroundTask * task in backgroundTasks) {
        if ([task isKindOfClass:[WKSnapshotRefreshBackgroundTask class]]) {
            WKSnapshotRefreshBackgroundTask *snapshotTask = (WKSnapshotRefreshBackgroundTask*)task;
            [snapshotTask setTaskCompletedWithDefaultStateRestored:YES estimatedSnapshotExpiration:[NSDate distantFuture] userInfo:nil];
        } else {
            [task setTaskCompleted];
        }
    }
}

@end
