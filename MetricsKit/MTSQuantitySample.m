//
//  MTSQuantitySample.m
//  Metrics
//
//  Created by Daniel Strokis on 4/7/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSQuantitySample.h"

@implementation MTSQuantitySample

- (instancetype)initWithDate:(NSDate *)date unitString:(NSString *)unit andAmount:(NSNumber *)amount {
    self = [super init];
    if (self) {
        _date = date;
        _unit = unit;
        _amount = amount;
    }
    return self;
}

@end
