//
//  NSValue+Color.m
//  Metrics
//
//  Created by Daniel Strokis on 4/9/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "NSValue+Color.h"

@implementation NSValue (Color)

+ (instancetype)valueWithCGColorRef:(CGColorRef)value {
    return [self valueWithBytes:value objCType:@encode(CGColorRef)];
}

- (CGColorRef)colorValue {
    CGColorRef value;
    [self getValue:&value];
    return value;
}

@end
