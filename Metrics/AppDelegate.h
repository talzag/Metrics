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

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary <NSString *, HKQuantityTypeIdentifier>*quantityTypeIdentifiers;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

