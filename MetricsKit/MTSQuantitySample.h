//
//  MTSQuantitySample.h
//  Metrics
//
//  Created by Daniel Strokis on 4/7/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTSQuantitySample : NSObject

@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *unit;
@property (nonatomic) NSNumber *amount;

- (instancetype)initWithDate:(NSDate *)date unitString:(NSString *)unit andAmount:(NSNumber *)amount;

@end
