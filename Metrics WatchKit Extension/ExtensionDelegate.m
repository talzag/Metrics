//
//  ExtensionDelegate.m
//  Metrics WatchKit Extension
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "ExtensionDelegate.h"
#import "MTSGraphsInterfaceController.h"

@implementation ExtensionDelegate

- (void)applicationDidFinishLaunching {
    if ([HKHealthStore isHealthDataAvailable]) {
        HKHealthStore *healthStore = [HKHealthStore new];
        [MTSHealthStoreManager requestReadAccessForHealthStore:healthStore completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (!success) {
                
            }
        }];
    }
}

- (void)applicationWillResignActive {
    [self saveContext];
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

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    @synchronized (self) {
        if (_persistentContainer == nil) {
            NSURL *modelURL = [[NSBundle bundleWithIdentifier:@"com.dstrokis.MetricsKitNano"] URLForResource:@"Metrics" withExtension:@"momd"];
            NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Metrics" managedObjectModel:model];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
#ifdef DEBUG
                    abort();
#endif
                }
            }];
        }
    }
    
    return _persistentContainer;
}

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
#ifdef DEBUG
        abort();
#endif
    }
}

@end
