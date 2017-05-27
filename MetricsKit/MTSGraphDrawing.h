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

#import "MTSGraph+MTSQueryable.h"
#import "MTSQuery.h"

extern NSString * const _Nonnull MTSGraphLineColorKey;
extern NSString * const _Nonnull MTSGraphDataPointsKey;
extern NSString * const _Nonnull MTSGraphDataIdentifierKey;

void MTSDrawGraph(CGContextRef _Nonnull context, CGRect rect, MTSGraph * _Nonnull graph);
NSDictionary * _Nullable MTSGraphDataPointsLocationMap(CGRect rect, MTSGraph * _Nonnull graph);


#endif /* MTSGraphDrawing_h */
