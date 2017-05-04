//
//  AppDelegate.m
//  Metrics
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "AppDelegate.h"
#import "MTSGraphsTableViewController.h"

@interface AppDelegate ()

@property (strong) HKHealthStore *healthStore;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UINavigationController *navController = (UINavigationController *)[[self window] rootViewController];
    MTSGraphsTableViewController *graphsViewController = [[navController viewControllers] firstObject];
    [graphsViewController setManagedObjectContext: [[self persistentContainer] viewContext]];
    
    if ([HKHealthStore isHealthDataAvailable]) {
        [self setHealthStore:[HKHealthStore new]];
        [self requestHealthSharingAuthorization];
    }
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

- (void)requestHealthSharingAuthorization {
    __weak AppDelegate *weakSelf = self;
    
    [MTSHealthStoreManager requestReadAccessForHealthStore:self.healthStore completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (!success) {
            NSLog(@"ERROR: %@", [error localizedDescription]);
        }
        
        AppDelegate *this = weakSelf;
        
        UINavigationController *navController = (UINavigationController *)[[this window] rootViewController];
        MTSGraphsTableViewController *graphsViewController = (MTSGraphsTableViewController *)[[navController viewControllers] firstObject];
        [graphsViewController setHealthStore:[this healthStore]];
    }];
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    @synchronized (self) {
        if (_persistentContainer == nil) {
            NSURL *modelURL = [[NSBundle bundleWithIdentifier:@"com.dstrokis.MetricsKit"] URLForResource:@"Metrics" withExtension:@"momd"];
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

#pragma mark - Core Data Saving support

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
