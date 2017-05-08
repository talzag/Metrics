//
//  NSColorBox.m
//  Metrics
//
//  Created by Daniel Strokis on 4/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSColorBox.h"

static NSString * const kCOLOR_KEY = @"com.dstrokis.Metrics.color";

@interface MTSColorBox ()

@property (nonatomic) UIColor *internalColor;

@end

@implementation MTSColorBox

- (instancetype)initWithUIColor:(UIColor *)color {
    self = [super init];
    if (self) {
        _internalColor = color;
        _numComponents = CGColorGetNumberOfComponents([color CGColor]);
        NSAssert(_numComponents == 4, @"Components not RGBA");
    }
    return self;
}

- (instancetype)initWithCGColorRef:(CGColorRef)value {
    return [self initWithUIColor:[UIColor colorWithCGColor:value]];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    UIColor *color = [aDecoder decodeObjectForKey:kCOLOR_KEY];
    return [self initWithUIColor:color];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[self internalColor] forKey:kCOLOR_KEY];
}

- (CGColorRef)color {
    return [[self internalColor] CGColor];
}

@end
