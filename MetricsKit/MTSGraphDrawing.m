//
//  MTSGraphDrawing.m
//  Metrics
//
//  Created by Daniel Strokis on 3/26/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphDrawing.h"

#define kMTSGRAPH_TOP_MARGIN  0.15
#define kMTSGRAPH_BOTTOM_MARGIN  0.15
#define kMTSGRAPH_LEFT_MARGIN  0.05
#define kMTSGRAPH_RIGHT_MARGIN  0.05

CGFloat MTSGraphTopMargin(CGRect rect) {
    return rect.size.height * kMTSGRAPH_TOP_MARGIN;
}

CGFloat MTSGraphBottomMargin(CGRect rect) {
    return rect.size.height * kMTSGRAPH_BOTTOM_MARGIN;
}

CGFloat MTSGraphLeftMargin(CGRect rect) {
    return rect.size.width * kMTSGRAPH_LEFT_MARGIN;
}

CGFloat MTSGraphRightMargin(CGRect rect) {
    return rect.size.width * kMTSGRAPH_RIGHT_MARGIN;
}

CGFloat MTSGraphHeight(CGRect rect) {
    return rect.size.height - MTSGraphBottomMargin(rect);
}

CGFloat MTSGraphWidth(CGRect rect) {
    return rect.size.width - (MTSGraphLeftMargin(rect) + MTSGraphRightMargin(rect));
}

CGFloat MTSGraphColumnWidth(CGRect rect, NSUInteger numElements) {
    if (numElements == 0) {
        return MTSGraphWidth(rect);
    }
    
    return MTSGraphWidth(rect) / numElements;
}

void drawGradient(CGContextRef context, CGRect rect, CGColorRef top, CGColorRef bottom) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (!top || !bottom) {
        CGFloat components[4] = { 1, 1, 1, 1 };
        CGColorRef white = CGColorCreate(colorSpace, components);
        
        CGContextSetFillColorWithColor(context, white);
        CGContextFillRect(context, rect);
        
        CGColorRelease(white);
    } else {
        const void *colors[] = { &top, &bottom };
        CFArrayRef colorsArray = CFArrayCreate(NULL, colors, 2, NULL);
        
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colorsArray, NULL);
        CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(0.0, rect.size.height), kCGGradientDrawsAfterEndLocation);
        
        CGGradientRelease(gradient);
        CFRelease(colorsArray);
    }
    
    CGColorSpaceRelease(colorSpace);
}

void drawGraphLines(CGContextRef context, CGRect rect) {
    CGMutablePathRef linePath = CGPathCreateMutable();
    CGContextSetLineWidth(context, 1.0);
    
    CGFloat components[4] = { 0, 0, 0, 1 };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef black = CGColorCreate(colorSpace, components);
    CGContextSetStrokeColorWithColor(context, black);
    CGColorRelease(black);
    CGColorSpaceRelease(colorSpace);
    
    // top line
    CGPoint topStart = CGPointMake(MTSGraphLeftMargin(rect), MTSGraphTopMargin(rect));
    CGPoint topEnd = CGPointMake(rect.size.width - MTSGraphRightMargin(rect), MTSGraphTopMargin(rect));
    CGPathMoveToPoint(linePath, NULL, topStart.x, topStart.y);
    CGPathAddLineToPoint(linePath, NULL, topEnd.x, topEnd.y);
    
    // middle line
    CGPoint midStart = CGPointMake(topStart.x, rect.size.height/2);
    CGPoint midEnd = CGPointMake(topEnd.x, rect.size.height/2);
    CGPathMoveToPoint(linePath, NULL, midStart.x, midStart.y);
    CGPathAddLineToPoint(linePath, NULL, midEnd.x, midEnd.y);
    
    // bottom line
    CGPoint bottomStart = CGPointMake(topStart.x, MTSGraphHeight(rect));
    CGPoint bottomEnd = CGPointMake(topEnd.x, MTSGraphHeight(rect));
    CGPathMoveToPoint(linePath, NULL, bottomStart.x, bottomStart.y);
    CGPathAddLineToPoint(linePath, NULL, bottomEnd.x, bottomEnd.y);
    
    // stroke main lines;
    CGContextAddPath(context, linePath);
    CGContextStrokePath(context);
    CGPathRelease(linePath);

    // Draw intermediate lines
    CGMutablePathRef midPath = CGPathCreateMutable();
    
    // upper mid line
    CGFloat upperMidY = midStart.y * 0.5 + MTSGraphTopMargin(rect) / 2.0;
    CGPoint upperMidStartPoint = CGPointMake(topStart.x, upperMidY);
    CGPoint upperMidEndPoint = CGPointMake(topEnd.x, upperMidY);
    CGPathMoveToPoint(midPath, NULL, upperMidStartPoint.x, upperMidStartPoint.y);
    CGPathAddLineToPoint(midPath, NULL, upperMidEndPoint.x, upperMidEndPoint.y);
    
    // lower mid line
    CGFloat lowerMidY = midStart.y * 1.5 - MTSGraphTopMargin(rect) / 2.0;
    CGPoint lowerMidStartPoint = CGPointMake(topStart.x, lowerMidY);
    CGPoint lowerMidEndPoint = CGPointMake(topEnd.x, lowerMidY);
    CGPathMoveToPoint(midPath, NULL, lowerMidStartPoint.x, lowerMidStartPoint.y);
    CGPathAddLineToPoint(midPath, NULL, lowerMidEndPoint.x, lowerMidEndPoint.y);

    // stroke intermediate lines
    const CGFloat dashes[] = { 6.0, 5.0 };
    CGContextSetLineDash(context, 0, dashes, 2);
    CGContextAddPath(context, midPath);
    CGContextStrokePath(context);
    CGPathRelease(midPath);
}

CGFloat MTSGraphPositionOnXAxisAtIndex(CGRect rect, int index, NSUInteger numElements) {
    return MTSGraphColumnWidth(rect, numElements) * index + MTSGraphLeftMargin(rect);
}

/*
CGFloat MTSGraphPositionOnYAxisForValue(CGFloat value, CGFloat maxValue) {
    if (!value || !maxValue) {
        return 0;
    }
 
    CGFloat height = self.actualGraphHeight - self.actualGraphTopMargin;
    CGFloat ratio = value / maxValue;
    return self.actualGraphHeight - ratio * height;
}
*/

void MTSGraphPlotDataPoints(CGContextRef context, CGRect rect, NSSet<NSDictionary<NSString *,id> *> *dataPoints) {
/*
     CGFloat maxValue = 0.0;
     for (NSDictionary <NSString *, id> *data in dataPoints) {
        NSArray *values = [data objectForKey:MTSGraphDataPointsKey];
         for (NSNumber *value in values) {
            double floatValue = [value doubleValue];
            maxValue = floatValue > maxValue ? floatValue : maxValue;
        }
     }
     
     
     UIBezierPath *graphLine = [UIBezierPath bezierPath];
     graphLine.lineWidth = 2.0;
     
     for (NSDictionary <NSString *, id> *data in dataPoints) {
         NSArray *values = [data objectForKey:MTSGraphDataPointsKey];
         UIColor *lineColor = [data objectForKey:MTSGraphLineColorKey];
         
         NSInteger size = values.count;
         CGFloat startX = [self positionOnXAxisForValueAtIndex:0 fromArrayOfSize:size];
         CGFloat startY = [self positionOnYAxisForValue:[[values firstObject] doubleValue] scaledForMaxValue:maxValue];
         CGPoint startingPoint = CGPointMake(startX, startY);
         [graphLine moveToPoint:startingPoint];
         
         for (int i = 1; i < size; i++) {
             CGFloat x = [self positionOnXAxisForValueAtIndex:i fromArrayOfSize:size];
             CGFloat y = [self positionOnYAxisForValue:[values[i] doubleValue] scaledForMaxValue:maxValue];
             CGPoint point = CGPointMake(x, y);
             [graphLine addLineToPoint:point];
         }
         
         
         [lineColor setStroke];
         [graphLine stroke];
         
         [graphLine removeAllPoints];
     }
 */
}

void MTSDrawGraph(MTSGraph *graph, CGContextRef context, CGRect rect) {
    CGContextSaveGState(context);
    
    // Clip to rounded corners
    CGPathRef clipPath = CGPathCreateWithRoundedRect(rect, 25, 25, NULL);
    CGContextAddPath(context, clipPath);
    CGContextClip(context);
    CGPathRelease(clipPath);

    // draw background
    CGContextSaveGState(context);
    
    CGColorRef top = NULL;
    CGColorRef bottom = NULL;
//    if ([graph topColor]) {
//        top = [graph topColor];
//    }
//    
//    if ([graph bottomColor]) {
//        bottom = [graph bottomColor];
//    }
    
    drawGradient(context, rect, top, bottom);
    CGContextRestoreGState(context);
    
    // draw graph lines
    CGContextSaveGState(context);
    drawGraphLines(context, rect);
    CGContextRestoreGState(context);

    // plot data points
    CGContextSaveGState(context);
    MTSGraphPlotDataPoints(context, rect, NULL);
    CGContextRestoreGState(context);
}
