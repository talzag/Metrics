//
//  GraphView.m
//  Metrics
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphView.h"

@implementation MTSGraphView

- (UIViewAutoresizing)autoresizingMask {
    return UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)setGraph:(MTSGraph *)graph {
    _graph = graph;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    BOOL drawPoints = NO;
    if ([self traitCollection].verticalSizeClass == UIUserInterfaceSizeClassCompact) {
        drawPoints = YES;
    }
    
    MTSDrawGraph(context, rect, [self graph], drawPoints);
}

- (void)needsRedraw:(NSNotification *)notification {
    [self setNeedsDisplay];
}

// TODO: Finish implementing interactivity
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

@end
