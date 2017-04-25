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

void MTSGraphPlotDataPoints(CGContextRef context, CGRect rect, NSArray <NSDictionary<NSString *,id> *> *dataPoints) {
    CGFloat maxValue = 0.0;
    for (NSDictionary <NSString *, id> *data in dataPoints) {
        NSArray *values = [data objectForKey:MTSGraphDataPointsKey];
        for (NSNumber *value in values) {
            double floatValue = [value doubleValue];
            maxValue = floatValue > maxValue ? floatValue : maxValue;
        }
    }

    CGContextSetLineWidth(context, 2.0);
    
    for (NSDictionary <NSString *, id> *data in dataPoints) {
        CGContextSaveGState(context);
        
        CGMutablePathRef graphPath = CGPathCreateMutable();

        MTSColorBox *lineColorBox = [data objectForKey:MTSGraphLineColorKey];
        CGColorRef lineColor = [lineColorBox color];
        CGContextSetStrokeColorWithColor(context, lineColor);
        
        NSArray <NSNumber *>*values = [data objectForKey:MTSGraphDataPointsKey];
        NSInteger size = values.count;
        if (!size) {
            continue;
        }
        
        if (size == 1) {
            CGFloat startX = MTSGraphPositionOnXAxisAtIndex(rect, 0, size);
            CGFloat endX = rect.size.width - MTSGraphRightMargin(rect);
            
            CGFloat y = MTSGraphPositionOnYAxisForValue(rect, [values[0] doubleValue], maxValue);
            
            CGPathMoveToPoint(graphPath, NULL, startX, y);
            CGPathAddLineToPoint(graphPath, NULL, endX, y);
            
            const CGFloat dashes[] = { 4.0, 4.0 };
            CGContextSetLineDash(context, 0, dashes, 2);
        } else {
            CGFloat startX = MTSGraphPositionOnXAxisAtIndex(rect, 0, size);
            CGFloat startY = MTSGraphPositionOnYAxisForValue(rect, [[values firstObject] doubleValue], maxValue);
            CGPathMoveToPoint(graphPath, NULL, startX, startY);
             
            for (int i = 1; i < size; i++) {
                CGFloat x = MTSGraphPositionOnXAxisAtIndex(rect, i, size);
                CGFloat y = MTSGraphPositionOnYAxisForValue(rect, [values[i] doubleValue], maxValue);
                 
                CGPathAddLineToPoint(graphPath, NULL, x, y);
            }
            
            CGContextSetLineDash(context, 0, NULL, 0);
        }
        
        CGContextAddPath(context, graphPath);
        CGContextStrokePath(context);
        
        CGPathRelease(graphPath);
        
        CGContextRestoreGState(context);
    }
}

void MTSDrawGraph(CGContextRef context, CGRect rect, NSArray <NSDictionary<NSString *,id> *> * _Nullable dataPoints, CGColorRef _Nullable topColor, CGColorRef _Nullable bottomColor) {
    CGContextRetain(context);
    CGContextSaveGState(context);
    
    // Clip to rounded corners
    CGPathRef clipPath = CGPathCreateWithRoundedRect(rect, 25, 25, NULL);
    CGContextAddPath(context, clipPath);
    CGContextClip(context);
    CGPathRelease(clipPath);

    // draw background
    CGContextSaveGState(context);
    drawGradient(context, rect, topColor, bottomColor);
    CGContextRestoreGState(context);
    
    // draw graph lines
    CGContextSaveGState(context);
    drawGraphLines(context, rect);
    CGContextRestoreGState(context);

    // plot data points
    CGContextSaveGState(context);
    MTSGraphPlotDataPoints(context, rect, dataPoints);
    CGContextRestoreGState(context);
    CGContextRelease(context);
}
