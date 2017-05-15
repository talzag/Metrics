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

/**
 Executes a graph's queries using the provided health store. This method returns immediately; to know when all queries have been run provide a completion handler. Once the completion handler is called, each of the graph's query objects will have it's fetchedDataPoints property populated.

 @param healthStore The health store against which the queries should be run.
 @param completionHandler An optional completion handler that will be called when all queries have finished executing. The only argument is an NSError object that will be non-null if there was an error executing any of the queries.
 */
- (void)executeQueriesWithHealthStore:(HKHealthStore * _Nonnull)healthStore
               usingCompletionHandler:(void (^ _Nullable)(NSError * _Nullable))completionHandler;

@end

#endif /* MTSGraph_h */
