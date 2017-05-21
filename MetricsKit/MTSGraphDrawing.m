//
//  MTSGraphDrawing.m
//  Metrics
//
//  Created by Daniel Strokis on 3/26/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphDrawing.h"

NSString * const _Nonnull MTSGraphLineColorKey = @"com.dstrokis.Mtrcs.lineColor";
NSString * const _Nonnull MTSGraphDataPointsKey = @"com.dstrokis.Mtrcs.data";
NSString * const _Nonnull MTSGraphDataIdentifierKey = @"com.dstrokis.Mtrcs.data-identifier";

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
    return rect.size.width - MTSGraphLeftMargin(rect) - MTSGraphRightMargin(rect);
}

CGFloat MTSGraphColumnWidth(CGRect rect, NSInteger numElements) {
    if (numElements <= 0) {
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
        const CGColorRef colors[] = { top, bottom };
        CFArrayRef colorsArray = CFArrayCreate(NULL, (void *)colors, 2, NULL);
        
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
    
    CGFloat components[4] = { 0, 0, 0, 0.5 };
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

void drawLabelsOnYAxis(CGContextRef context, CGRect rect, NSArray <NSString *> *labels) {
    CGFloat x = rect.size.width - MTSGraphLeftMargin(rect);
    CGFloat top = MTSGraphTopMargin(rect);
    CGFloat bottom = MTSGraphHeight(rect);
    
    CGFloat labelSpacing = (bottom - top) / [labels count];
    
    NSInteger i;
    for (i = 0; i < [labels count]; i++) {
        NSString *label = labels[i];
        
        CGFloat y = i * labelSpacing;
        CGPoint labelSpot = CGPointMake(x, y);
        
        [label drawAtPoint:labelSpot withAttributes:nil];
    }
}

void drawLabelsOnXAxis(CGContextRef context, CGRect rect, NSArray <NSString *> *labels) {
    CGFloat left = rect.size.width - MTSGraphLeftMargin(rect);
    CGFloat right = rect.size.width - MTSGraphRightMargin(rect);
    CGFloat y = MTSGraphHeight(rect);
    
    
    CGFloat labelSpacing = (right - left) / [labels count];
    
    NSInteger i;
    for (i = 0; i < [labels count]; i++) {
        NSString *label = labels[i];
        
        CGFloat x = i * labelSpacing;
        CGPoint labelSpot = CGPointMake(x, y);
        
        [label drawAtPoint:labelSpot withAttributes:nil];
    }
}

CGFloat MTSGraphPositionOnXAxisAtIndex(CGRect rect, int index, NSUInteger numElements) {
    return MTSGraphColumnWidth(rect, numElements - 1) * index + MTSGraphLeftMargin(rect);
}

CGFloat MTSGraphPositionOnYAxisForValue(CGRect rect, CGFloat value, CGFloat maxValue) {
    if (!value || !maxValue) {
        return MTSGraphHeight(rect);
    }
 
    CGFloat height = MTSGraphHeight(rect) - MTSGraphTopMargin(rect);
    CGFloat ratio = value / maxValue;
    return MTSGraphHeight(rect) - ratio * height;
}

void MTSGraphDataPointsLocationMap(CGRect rect, NSArray <NSNumber *> *dataPoints) {
    // iterate over the dataPoints
}

CGFloat MTSGraphQueryDataPointsMax(NSArray <MTSQuery *> *graphQueries) {
    CGFloat maxValue = 0.0;
    for (MTSQuery *query in graphQueries) {
        NSArray <NSNumber *> *values = [query fetchedDataPoints];
        for (NSNumber *value in values) {
            double floatValue = [value doubleValue];
            maxValue = floatValue > maxValue ? floatValue : maxValue;
        }
    }
    
    return maxValue;
}

void MTSGraphPlotDataPoints(CGContextRef context, CGRect rect, MTSGraph *graph) {
    if (![graph queries] || [[graph queries] count] == 0) {
        return;
    }
    
    NSArray <MTSQuery *> *graphQueries = [[graph queries] allObjects];
    
    CGFloat maxValue = MTSGraphQueryDataPointsMax(graphQueries);
    
    if (![graph yAxisLabels]) {
        NSArray <NSString *> *yAxisLabels = @[
                                              [NSString stringWithFormat:@"%.0f", 0.0],
                                              [NSString stringWithFormat:@"%.0f", maxValue]
                                              ];
        [graph setYAxisLabels:yAxisLabels];
    }
    
    drawLabelsOnYAxis(context, rect, [graph yAxisLabels]);

    CGContextSetLineWidth(context, 2.0);
    
    for (MTSQuery *query in graphQueries) {
        NSArray <NSNumber *> *values = [query fetchedDataPoints];
        NSInteger size = values.count;
        if (!size) {
            continue;
        }
        
        CGMutablePathRef graphPath = CGPathCreateMutable();
    
        CGFloat startX = MTSGraphPositionOnXAxisAtIndex(rect, 0, size);
        CGFloat startY = MTSGraphPositionOnYAxisForValue(rect, [[values firstObject] doubleValue], maxValue);
        
        if (size == 1) {
            CGFloat endX = rect.size.width - MTSGraphRightMargin(rect);
            
            CGPathMoveToPoint(graphPath, NULL, startX, startY);
            CGPathAddLineToPoint(graphPath, NULL, endX, startY);
            
            const CGFloat dashes[] = { 4.0, 4.0 };
            CGContextSetLineDash(context, 0, dashes, 2);
        } else {
            CGPathMoveToPoint(graphPath, NULL, startX, startY);
            
            for (int i = 1; i < size; i++) {
                CGFloat x = MTSGraphPositionOnXAxisAtIndex(rect, i, size);
                CGFloat y = MTSGraphPositionOnYAxisForValue(rect, [values[i] doubleValue], maxValue);
                
                CGPathAddLineToPoint(graphPath, NULL, x, y);
            }
            
            CGContextSetLineDash(context, 0, NULL, 0);
        }
        
        CGContextAddPath(context, graphPath);
        
        UIColor *configColor = [query lineColor];
        CGColorRef lineColor = [configColor CGColor];
        CGContextSetStrokeColorWithColor(context, lineColor);
        
        CGContextStrokePath(context);
        
        CGPathRelease(graphPath);
    }
}

void MTSDrawGraph(CGContextRef context, CGRect rect, MTSGraph *graph) {
    CGContextRetain(context);
    CGContextSaveGState(context);

    // draw background
    CGContextSaveGState(context);
    drawGradient(context, rect, (__bridge CGColorRef)([graph topColor]), (__bridge CGColorRef)([graph bottomColor]));
    CGContextRestoreGState(context);
    
    // draw graph lines
    CGContextSaveGState(context);
    drawGraphLines(context, rect);
    CGContextRestoreGState(context);
    
    // draw graph labels
    if ([graph xAxisLabels]) {
        CGContextSaveGState(context);
        drawLabelsOnXAxis(context, rect, [graph xAxisLabels]);
        CGContextRestoreGState(context);
    }
    
    if ([graph yAxisLabels]) {
        CGContextSaveGState(context);
        drawLabelsOnYAxis(context, rect, [graph yAxisLabels]);
        CGContextRestoreGState(context);
    }
    
    // plot data points
    CGContextSaveGState(context);
    MTSGraphPlotDataPoints(context, rect, graph);
    CGContextRestoreGState(context);
    
    CGContextRelease(context);
}
