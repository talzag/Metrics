//
//  MTSRealCalorieValue.h
//  Metrics
//
//  Created by Daniel Strokis on 3/19/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#ifndef MTSRealCalorieValue_h
#define MTSRealCalorieValue_h

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

void MTSRealCalorieValue(HKHealthStore *healthStore, NSDate *start, NSDate *end, void (^completionHandler)(double calories, NSError *error));

#endif /* MTSRealCalorieValue_h */
