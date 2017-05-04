//
//  MTSDataType.h
//  Metrics
//
//  Created by Daniel Strokis on 5/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>
#import "MTSColorBox.h"

@interface MTSQueryDataConfiguration : NSObject

@property (nonatomic) HKQuantityTypeIdentifier healthKitQuantityTypeIdentifier;
@property (nonatomic) NSString *quantityTypeDisplayName;
@property (nonatomic) MTSColorBox *lineColor;

@end
