//
//  MTSGraph+CoreDataClass.h
//  Metrics
//
//  Created by Daniel Strokis on 4/22/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HKHealthStore, MTSColorBox, MTSQuery;

NS_ASSUME_NONNULL_BEGIN

@interface MTSGraph : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "MTSGraph+CoreDataProperties.h"
