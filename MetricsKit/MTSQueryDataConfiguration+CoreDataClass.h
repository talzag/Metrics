//
//  MTSQueryDataConfiguration+CoreDataClass.h
//  Metrics
//
//  Created by Daniel Strokis on 5/6/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MTSColorBox.h"
#import "MTSQuery.h"

@class MTSColorBox, NSArray, MTSQuery;

NS_ASSUME_NONNULL_BEGIN

@interface MTSQueryDataConfiguration : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "MTSQueryDataConfiguration+CoreDataProperties.h"
