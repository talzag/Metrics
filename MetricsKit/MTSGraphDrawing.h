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

void MTSDrawGraph(CGContextRef _Nonnull context, CGRect rect, NSSet<NSDictionary<NSString *,id> *> * _Nullable dataPoints);

#endif /* MTSGraphDrawing_h */
