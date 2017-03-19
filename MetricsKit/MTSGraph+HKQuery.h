//
//  MTSGraph+HKQuery.h
//  Metrics
//
//  Created by Daniel Strokis on 2/26/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import Foundation;
@import HealthKit;

#import "MTSGraph+CoreDataClass.h"

@interface MTSGraph (HKQuery)

- (void)populateGraphDataByQueryingHealthStore:(HKHealthStore * _Nonnull)healthStore completionHandler:(void (^ _Nullable)(NSArray<__kindof HKSample *> * _Nullable samples))completionHandler ;

@end
