//
//  MTSGraph.h
//  Metrics
//
//  Created by Daniel Strokis on 3/14/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#ifndef MTSGraph_h
#define MTSGraph_h

#include <Foundation/Foundation.h>
#include <HealthKit/HealthKit.h>
#import "MTSGraph+CoreDataClass.h"
#import "MTSQueryDataConfiguration.h"

@interface MTSGraph (MTSQueryable)

- (void)executeQueryWithHealthStore:(HKHealthStore * _Nonnull)healthStore usingCompletionHandler:(void (^ _Nullable)(NSError * _Nullable))completionHandler;

@end

#endif /* MTSGraph_h */
