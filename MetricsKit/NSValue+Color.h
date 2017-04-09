//
//  NSValue+Color.h
//  Metrics
//
//  Created by Daniel Strokis on 4/9/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSValue (Color)

+ (instancetype)valueWithCGColorRef:(CGColorRef)value;

@property (readonly) CGColorRef colorValue;

@end
