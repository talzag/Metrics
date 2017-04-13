//
//  NSColorBox.m
//  Metrics
//
//  Created by Daniel Strokis on 4/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSColorBox.h"

@implementation MTSColorBox

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
}

+ (instancetype)valueWithCGColorRef:(CGColorRef)value {
    return (MTSColorBox *)[super valueWithBytes:value objCType:@encode(CGColorRef)];
}

- (CGColorRef)colorValue {
    CGColorRef value;
    [self getValue:&value];
    return value;
}

@end
