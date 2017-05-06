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

@property (nonatomic, nonnull) HKQuantityTypeIdentifier healthKitQuantityTypeIdentifier;
@property (nonatomic, nonnull) NSString *quantityTypeDisplayName;
@property (nonatomic, nullable) MTSColorBox *lineColor;
@property (nonatomic, nullable) NSArray <NSNumber *>*fetchedDataPoints;

- (instancetype _Nonnull )initWithIdentifier:(HKQuantityTypeIdentifier _Nonnull)identifier
                       displayName:(NSString *_Nonnull)displayName
                                   lineColor:(MTSColorBox *_Nullable)lineColor
                           fetchedDataPoints:(NSArray <NSNumber *>*_Nullable)dataPoints;

@end
