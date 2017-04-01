//
//  ExtensionDelegate.h
//  Metrics WatchKit Extension
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import WatchKit;
@import HealthKit;
@import CoreData;

#import <MetricsKit/MetricsKit.h>

@interface ExtensionDelegate : NSObject <WKExtensionDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@end
