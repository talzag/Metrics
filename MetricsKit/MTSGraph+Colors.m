//
//  MTSGraph+Colors.m
//  Metrics
//
//  Created by Daniel Strokis on 4/9/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTSGraph.h"
#import "MTSColorBox.h"

@implementation MTSGraph (Colors)

- (CGColorRef)transformedTopColor {
    if ([self topColor]) {
        return [[self topColor] color];
    }
    
    return nil;
}

- (CGColorRef)transformedBottomColor {
    if ([self bottomColor]) {
        return [[self bottomColor] color];
    }
    
    return nil;
}

@end
