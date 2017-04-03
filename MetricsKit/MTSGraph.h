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

extern NSString * const _Nonnull MTSGraphLineColorKey;
extern NSString * const _Nonnull MTSGraphDataPointsKey;
extern NSString * const _Nonnull MTSGraphDataIdentifierKey;

@interface MTSGraph (MTSQueryable)

- (void)executeQueryUsingHealthStore:(HKHealthStore * _Nonnull)healthStore
               withCompletionHandler:(void (^ _Nullable)(NSArray * _Nullable, NSError * _Nullable))completionHandler;

@end

#endif /* MTSGraph_h */
