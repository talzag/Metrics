//
//  MTSGraphDrawing.h
//  Metrics
//
//  Created by Daniel Strokis on 3/26/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#ifndef MTSGraphDrawing_h
#define MTSGraphDrawing_h

@import Foundation;
@import CoreGraphics;

#import "MTSGraph.h"

extern NSString * const _Nonnull MTSGraphLineColorKey;
extern NSString * const _Nonnull MTSGraphDataPointsKey;
extern NSString * const _Nonnull MTSGraphDataIdentifierKey;

void MTSDrawGraph(CGContextRef _Nonnull context, CGRect rect, NSArray <NSDictionary<NSString *,id> *> * _Nullable dataPoints, CGColorRef _Nullable topColor, CGColorRef _Nullable bottomColor);

#endif /* MTSGraphDrawing_h */
