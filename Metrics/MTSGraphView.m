//
//  GraphView.m
//  Metrics
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphView.h"
#import "MTSGraphView+Methods.h"

NSString *MTSGraphLineColorKey = @"com.dstrokis.Mtrcs.lineColor";
NSString *MTSGraphDataPointsKey = @"com.dstrokis.Mtrcs.data";

@implementation MTSGraphView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initalizeValues];
    }
    return  self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initalizeValues];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initalizeValues];
    }
    return self;
}

- (void)initalizeValues {
    _topColor = [UIColor whiteColor];
    _bottomColor = [UIColor whiteColor];
    _needsDataPointsDisplay = NO;
    _dataPoints = [NSSet set];
    _graphTopMarginPercent = _graphBottomMarginPercent = 0.15;
    _graphLeftRightMarginPercent = 0.05;
    _drawIntermediateLines = YES;
}

- (void)setDataPoints:(NSSet<NSDictionary<NSString *,id> *> *)dataPoints {
    _dataPoints = dataPoints;
    
    _needsDataPointsDisplay = [_dataPoints count] > 0;
    
    if (_needsDataPointsDisplay) {
        [self setNeedsDisplay];
    }
}

- (CGFloat)actualGraphTopMargin {
    return self.bounds.size.height * _graphTopMarginPercent;
}

- (CGFloat)actualGraphBottomMargin {
    return self.bounds.size.height * _graphBottomMarginPercent;
}

- (CGFloat)actualGraphLeftRightMargin {
    return self.bounds.size.width * _graphLeftRightMarginPercent;
}

- (CGFloat)actualGraphHeight {
    return self.bounds.size.height - self.actualGraphBottomMargin;
}

- (CGFloat)actualGraphWidth {
    return self.bounds.size.width - self.actualGraphLeftRightMargin * 2.0;
}

- (void)drawBackgroundInRect:(CGRect)rect withContext:(CGContextRef)context {
    if ([_topColor isEqual:_bottomColor] && ![_topColor isEqual:[UIColor clearColor]]) {
        [_topColor setFill];
        CGContextFillRect(context, rect);
    } else {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        NSArray *colors = @[(id)[_topColor CGColor], (id)[_bottomColor CGColor]];
        
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, NULL);
        CGPoint startPoint = CGPointZero;
        CGPoint endpoint = CGPointMake(0.0, rect.size.height);
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endpoint, kCGGradientDrawsBeforeStartLocation);
        
        CGColorSpaceRelease(colorSpace);
        CGGradientRelease(gradient);
    }
}

- (CGFloat)columnWidthForArraySize:(NSInteger)numberOfElements {
    CGFloat graphWidth = self.bounds.size.width - self.actualGraphLeftRightMargin * 2.0;
    numberOfElements--;
    if (numberOfElements) {
        return graphWidth / numberOfElements;
    } else {
        return graphWidth;
    }
}

- (CGFloat)positionOnXAxisForValueAtIndex:(int)index fromArrayOfSize:(NSInteger)size {
    return [self columnWidthForArraySize:size] * index + self.actualGraphLeftRightMargin;
}

- (CGFloat)positionOnYAxisForValue:(CGFloat)value scaledForMaxValue:(CGFloat)maxValue {
    CGFloat height = self.actualGraphHeight - self.actualGraphTopMargin;
    CGFloat ratio = value / maxValue;
    return self.actualGraphHeight - ratio * height;
}

- (void)plotDataPoints:(NSSet<NSDictionary<NSString *,id> *> *)dataPoints onGraphInRect:(CGRect)rect withContext:(CGContextRef)context {
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
}

- (void)drawGraphLinesinRect:(CGRect)rect withContext:(CGContextRef)context {
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath setLineWidth:1.0];
    [[UIColor grayColor] setStroke];
    
    CGFloat startX = [self actualGraphLeftRightMargin];
    CGFloat endX = rect.size.width - [self actualGraphLeftRightMargin];

    // Draw main lines
    CGPoint topStartPoint = CGPointMake(startX, self.actualGraphTopMargin);
    CGPoint topEndPoint = CGPointMake(endX, self.actualGraphTopMargin);
    [linePath moveToPoint:topStartPoint];
    [linePath addLineToPoint:topEndPoint];
    
    CGPoint midStartPoint = CGPointMake(startX, rect.size.height / 2.0);
    CGPoint midEndPoint = CGPointMake(endX, rect.size.height / 2.0);
    [linePath moveToPoint:midStartPoint];
    [linePath addLineToPoint:midEndPoint];
    
    CGPoint bottomStartPoint = CGPointMake(startX, rect.size.height - self.actualGraphBottomMargin);
    CGPoint bottomEndPoint = CGPointMake(endX, rect.size.height - self.actualGraphBottomMargin);
    [linePath moveToPoint:bottomStartPoint];
    [linePath addLineToPoint:bottomEndPoint];
    
    [linePath stroke];
    
    if (!self.drawIntermediateLines) {
        return;
    }
    
    // Draw intermediate lines
    CGFloat upperMidY = midStartPoint.y * 0.5 + self.actualGraphTopMargin / 2.0;
    CGPoint upperIntermediateStartPoint = CGPointMake(startX, upperMidY);
    CGPoint upperIntermediateEndPoint = CGPointMake(endX, upperMidY);
    [linePath moveToPoint:upperIntermediateStartPoint];
    [linePath addLineToPoint:upperIntermediateEndPoint];
    
    CGFloat lowerMidY = midStartPoint.y * 1.5 - self.actualGraphTopMargin / 2.0;
    CGPoint lowerIntermediateStartPoint = CGPointMake(startX, lowerMidY);
    CGPoint lowerIntermediateEndPoint = CGPointMake(endX, lowerMidY);
    [linePath moveToPoint:lowerIntermediateStartPoint];
    [linePath addLineToPoint:lowerIntermediateEndPoint];
    
    [[UIColor colorWithWhite:0.5 alpha:0.65] setStroke];
    const CGFloat dashes[] = { 6.0, 5.0 };
    [linePath setLineDash:dashes count:2 phase:0];
    [linePath stroke];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Add rounded corners clip
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:25.0];
    [clipPath addClip];
    
    // Draw gradient
    CGContextSaveGState(context);
    [self drawBackgroundInRect:rect withContext:context];
    CGContextRestoreGState(context);
    
    // Draw graph lines
    CGContextSaveGState(context);
    [self drawGraphLinesinRect:rect withContext:context];
    CGContextRestoreGState(context);
    
    // Return early if there's no points to plot
    if (!_needsDataPointsDisplay || [_dataPoints count] == 0) {
        return;
    }
    _needsDataPointsDisplay = NO;
    
    
    // Plot data points
    CGContextSaveGState(context);
    [self plotDataPoints:_dataPoints onGraphInRect:rect withContext:context];
    CGContextRestoreGState(context);
}

@end
