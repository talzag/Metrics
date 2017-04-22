//
//  ExtensionDelegate.m
//  Metrics WatchKit Extension
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "ExtensionDelegate.h"
#import "InterfaceController.h"
#import "MTSGraphsInterfaceController.h"

@implementation ExtensionDelegate

- (void)applicationDidFinishLaunching {
    MTSGraphsInterfaceController *graphsController = (MTSGraphsInterfaceController *)[[WKExtension sharedExtension] rootInterfaceController];
    [graphsController setManagedObjectContext:[[self persistentContainer] viewContext]];
    
    // TODO: Implement delegate methods to enable access using iPhone
    if ([HKHealthStore isHealthDataAvailable]) {
        HKHealthStore *healthStore = [HKHealthStore new];
        
        [MTSHealthStoreManager requestReadAccessForHealthStore:healthStore completionHandler:^(BOOL success, NSError * _Nullable error) {
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
