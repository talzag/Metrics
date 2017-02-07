//
//  MTSGraph.h
//  Metrics
//
//  Created by Daniel Strokis on 2/5/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTSGraph : NSObject

@property NSString *title;
@property NSDictionary <NSString *, id>*dataPoints;

/*
 Data compared over time, in this case across a week
 
 @"y": @["M", "T", "W", "T", "F"]
 
 Data set 1:
 @"x1": @[ 5,   1,   2,   3,   1]
 
 Data set 2:
 @"x2": @[ 1,   1,   2,   3,   5]
 */

@end
