//
//  MTSGraph.h
//  Metrics
//
//  Created by Daniel Strokis on 2/5/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *MTSGraphLineColorKey;
extern NSString *MTSGraphDataPointsKey;

@interface MTSGraph : NSObject

@property NSString *title;
@property NSString *xAxisTitle;
@property NSString *yAxisTitle;
@property NSString *xAxisLabels;
@property NSDictionary <NSString *, id>*dataPoints;

@end
