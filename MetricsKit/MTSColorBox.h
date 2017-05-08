//
//  NSColorBox.h
//  Metrics
//
//  Created by Daniel Strokis on 4/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import Foundation;
@import CoreGraphics;

#if TARGET_OS_WATCH
@import WatchKit;
#else
@import UIKit;
#endif

@interface MTSColorBox : NSObject <NSCoding>

@property NSUInteger numComponents;

- (instancetype)initWithUIColor:(UIColor *)color;
- (instancetype)initWithCGColorRef:(CGColorRef)value;
- (CGColorRef)color;

@end
