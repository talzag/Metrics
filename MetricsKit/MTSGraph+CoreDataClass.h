//
//  MTSGraph+CoreDataClass.h
//  Metrics
//
//  Created by Daniel Strokis on 3/26/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreGraphics/CoreGraphics.h>
#import <HealthKit/HealthKit.h>

#if TARGET_OS_WATCH
@import WatchKit;
#else
@import UIKit;
#endif

@class MTSQuery;

NS_ASSUME_NONNULL_BEGIN

@interface MTSGraph : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "MTSGraph+CoreDataProperties.h"
