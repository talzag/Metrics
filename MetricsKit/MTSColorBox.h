//
//  NSColorBox.h
//  Metrics
//
//  Created by Daniel Strokis on 4/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import Foundation;
@import CoreGraphics;

@interface MTSColorBox : NSObject <NSCoding>

- (instancetype)initWithCGColorRef:(CGColorRef)value;

@property (nonatomic, readonly) CGColorRef color;
@property (nonatomic) NSUInteger numComponents;

@end
