//
//  MTSQuery+CoreDataClass.h
//  Metrics
//
//  Created by Daniel Strokis on 3/26/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#if TARGET_OS_WATCH
@import WatchKit;
#else
@import UIKit;
#endif

@class MTSGraph, NSSet;

NS_ASSUME_NONNULL_BEGIN

@interface MTSQuery : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "MTSQuery+CoreDataProperties.h"
