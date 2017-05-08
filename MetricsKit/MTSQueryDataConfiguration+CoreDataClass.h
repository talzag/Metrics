//
//  MTSQueryDataConfiguration+CoreDataClass.h
//  Metrics
//
//  Created by Daniel Strokis on 5/6/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#if TARGET_OS_WATCH
@import WatchKit;
#else
@import UIKit;
#endif

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MTSQuery.h"

@class NSArray, MTSQuery;

NS_ASSUME_NONNULL_BEGIN

@interface MTSQueryDataConfiguration : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "MTSQueryDataConfiguration+CoreDataProperties.h"
