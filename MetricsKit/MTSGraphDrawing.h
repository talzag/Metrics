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

void MTSDrawGraph(MTSGraph *graph, CGContextRef context, CGRect rect);

#endif /* MTSGraphDrawing_h */
