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
@interface MTSGraph (MTSQueryable)

- (void)executeQueryWithHealthStore:(HKHealthStore * _Nonnull)healthStore usingCompletionHandler:(void (^ _Nullable)(NSArray * _Nullable, NSError * _Nullable))completionHandler;

- (void)graphDataFromQueryResults:(NSArray <NSArray<HKQuantitySample *> *>* _Nonnull)results
                  withHealthStore:(HKHealthStore * _Nonnull)healthStore
                completionHandler:(void (^ _Nonnull)(NSArray <NSDictionary<NSString *,id> *> * _Nullable, NSError * _Nullable))completionHandler;

@end

#endif /* MTSGraph_h */
