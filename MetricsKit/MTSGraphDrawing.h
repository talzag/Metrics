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

void MTSDrawGraph(CGContextRef _Nonnull context, CGRect rect, MTSGraph * _Nonnull graph);

// Add method to create map of points to view locations

#endif /* MTSGraphDrawing_h */
