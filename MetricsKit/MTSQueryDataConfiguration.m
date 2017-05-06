//
//  MTSDataType.m
//  Metrics
//
//  Created by Daniel Strokis on 5/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSQueryDataConfiguration.h"

@implementation MTSQueryDataConfiguration

- (instancetype _Nonnull )initWithIdentifier:(HKQuantityTypeIdentifier _Nonnull)identifier
                                 displayName:(NSString *_Nonnull)displayName
                                   lineColor:(MTSColorBox *_Nullable)lineColor
                           fetchedDataPoints:(NSArray <NSNumber *>*_Nullable)dataPoints
{
    self = [super init];
    if (self) {
        _healthKitQuantityTypeIdentifier = identifier;
        _quantityTypeDisplayName = displayName;
        _lineColor = lineColor;
        _fetchedDataPoints = dataPoints;
    }
    return self;
}

@end
