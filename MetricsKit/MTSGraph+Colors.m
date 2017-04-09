//
//  MTSGraph+Colors.m
//  Metrics
//
//  Created by Daniel Strokis on 4/9/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTSGraph.h"
#import "NSValue+Color.h"

@implementation MTSGraph (Colors)

- (CGColorRef)transformedTopColor {
    return [[self topColor] colorValue];
}

- (CGColorRef)transformedBottomColor {
    return [[self bottomColor] colorValue];
}

@end
