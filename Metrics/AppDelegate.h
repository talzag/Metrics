//
//  AppDelegate.h
//  Metrics
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <UIKit/UIKit.h>
@import HealthKit;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) NSArray <HKQuantityTypeIdentifier>*quantityTypeIdentifiers;
@property (nonatomic) NSArray <HKCategoryTypeIdentifier>*categoryTypeIdentifiers;

@end

