//
//  GraphView.m
//  Metrics
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphView.h"

@implementation MTSGraphView

- (void)setGraph:(MTSGraph *)graph {
    _graph = graph;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    MTSDrawGraph(context, rect, [self graph]);
}

@end
