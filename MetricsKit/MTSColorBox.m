//
//  NSColorBox.m
//  Metrics
//
//  Created by Daniel Strokis on 4/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSColorBox.h"

static NSString * const kCOMPONENTS_KEY = @"com.dstrokis.Metrics.color.components";
static NSString * const kR = @"r";
static NSString * const kG = @"g";
static NSString * const kB = @"b";
static NSString * const kA = @"a";

@interface MTSColorBox ()

@end

@implementation MTSColorBox

- (instancetype)initWithCGColorRef:(CGColorRef)value {
    self = [super init];
    if (self) {
        _color = value;
        _numComponents = CGColorGetNumberOfComponents(value);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    NSArray *keys = @[kR, kG, kB, kA];
    CGFloat components[4];
    int i = 0;
    for (NSString *key in keys) {
        CGFloat component = [aDecoder decodeDoubleForKey:key];
        components[i] = component;
        i++;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpace, components);
    _numComponents = CGColorGetNumberOfComponents(color);
    _color = color;
    CGColorRelease(color);
    CGColorSpaceRelease(colorSpace);
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    const CGFloat *components = CGColorGetComponents(_color);
    NSArray *keys = @[kR, kG, kB, kA];
    int i = 0;
    for (NSString *key in keys) {
        [aCoder encodeDouble:components[i] forKey:key];
        i++;
    }
}

@end
