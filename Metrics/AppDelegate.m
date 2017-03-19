//
//  AppDelegate.m
//  Metrics
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "AppDelegate.h"
#import "MTSGraphCollectionViewController.h"

@interface AppDelegate ()

@property (strong) HKHealthStore *healthStore;
@property (strong, nonatomic) NSDictionary <NSString *, HKQuantityTypeIdentifier>*quantityTypeIdentifiers;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.quantityTypeIdentifiers = MTSQuantityTypeIdentifiers();
    
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    MTSGraphCollectionViewController *graphsViewController = (MTSGraphCollectionViewController *)navController.viewControllers.firstObject;
    graphsViewController.managedObjectContext = self.persistentContainer.viewContext;
    graphsViewController.quantityTypeIdentifiers = self.quantityTypeIdentifiers;
    
    if ([HKHealthStore isHealthDataAvailable]) {
        self.healthStore = [[HKHealthStore alloc] init];
        [self requestHealthSharingAuthorization];
    }
    
    return YES;
}

- (void)requestHealthSharingAuthorization {
    __weak AppDelegate *weakSelf = self;
    [MTSHealthDataCoordinator requestReadAccessForHealthStore:self.healthStore
                                            completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (!success) {
            NSLog(@"ERROR: %@", error.localizedDescription);
            abort();
        }
        
        AppDelegate *delegate = weakSelf;
        
        UINavigationController *navController = (UINavigationController *)[delegate.window rootViewController];
        MTSGraphCollectionViewController *graphViewController = (MTSGraphCollectionViewController *)[[navController viewControllers] firstObject];
        graphViewController.healthStore = delegate.healthStore;
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
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
#ifdef DEBUG
        abort();
#endif
    }
}

@end
