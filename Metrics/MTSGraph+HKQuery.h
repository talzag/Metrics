//
//  MTSGraph+HKQuery.h
//  Metrics
//
//  Created by Daniel Strokis on 2/26/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>
#import "MTSGraph+CoreDataClass.h"

@interface MTSGraph (HKQuery)

- (void)populateGraphDataByQueryingHealthStore:(HKHealthStore *)healthStore;

@end
