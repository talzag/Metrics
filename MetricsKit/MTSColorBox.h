//
//  NSColorBox.h
//  Metrics
//
//  Created by Daniel Strokis on 4/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import Foundation;
@import CoreGraphics;

@interface MTSColorBox : NSValue

+ (instancetype)valueWithCGColorRef:(CGColorRef)value;

@property (readonly) CGColorRef colorValue;

@end
