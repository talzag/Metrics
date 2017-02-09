//
//  GraphView.m
//  Metrics
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphView.h"

@interface MTSGraphView ()

@property (nonatomic) BOOL needsDataPointsDisplay;

@property NSUInteger graphTopMarginPercent;
@property NSUInteger graphBottomMarginPercent;
@property NSUInteger graphLeftRightMarginPercent;

@property (readonly) CGFloat actualGraphTopMargin;
@property (readonly) CGFloat actualGraphBottomMargin;
@property (readonly) CGFloat actualGraphLeftRightMargin;

@end

@implementation MTSGraphView

- (instancetype)init {
    self = [super init];
    if (self) {
        _topColor = [UIColor cyanColor];
        _bottomColor = [UIColor blueColor];
        _needsDataPointsDisplay = NO;
        _dataPoints = [NSArray array];
        _graphTopMarginPercent = _graphBottomMarginPercent = 0.15;
        _graphLeftRightMarginPercent = 0.05;
    }
    return  self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _topColor = [UIColor cyanColor];
        _bottomColor = [UIColor blueColor];
        _needsDataPointsDisplay = NO;
        _dataPoints = [NSArray array];
        _graphTopMarginPercent = _graphBottomMarginPercent = 0.15;
        _graphLeftRightMarginPercent = 0.05;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _topColor = [UIColor cyanColor];
        _bottomColor = [UIColor blueColor];
        _needsDataPointsDisplay = NO;
        _dataPoints = [NSArray array];
        _graphTopMarginPercent = _graphBottomMarginPercent = 0.15;
        _graphLeftRightMarginPercent = 0.05;
    }
    return self;
}

- (void)setDataPoints:(NSArray<NSArray<id> *> *)dataPoints {
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

/*
- (CGFloat) xAxisColumnWidthForNumberOfDataPoints: (NSUInteger)numberOfDataPoints {
    return (self.frame.size.width - ([self graphLeftRightMarginPercent] * 2)) / numberOfDataPoints;
}

- (CGFloat)pointOnXAxisForColumn:(NSInteger)column inRect: (CGRect)rect {
    CGFloat point;
    
    const CGFloat margin = 20.0;
    
    CGFloat spacer = rect.size.width - (margin * 2.0 - 4);
    spacer /= [_dataPoints count] - 1;
    point = spacer * column;
    point += margin + 2.0;
    
    return point;
}

- (CGFloat)pointOnYAxis: (NSNumber *)point inDataSet: (NSArray *)dataPoints inRect: (CGRect)rect {
    CGFloat scaledPoint;
    
    const CGFloat topBorder = 50.0;
    const CGFloat bottomBorder = 50.0;
    const CGFloat graphHeight = rect.size.height - topBorder - bottomBorder;
    
    NSNumber *maxPoint;
    for (int i = 0; i < [dataPoints count]; i++) {
        NSNumber *num = dataPoints[i];
        if (i == 0) {
            maxPoint = num;
            continue;
        }
        
        NSNumber *prev = dataPoints[i - 1];
        maxPoint = [prev compare:num] == NSOrderedAscending ? num : prev;
    }
    
    scaledPoint = [point doubleValue] / [maxPoint doubleValue] * graphHeight;
    scaledPoint = graphHeight + topBorder - scaledPoint;
    
    return scaledPoint;
}
*/

- (void)plotDataPoints:(NSArray *)dataPoints onGraphInRect:(CGRect)rect withContext:(CGContextRef)context {

//    for (NSArray *points in dataPoints) {
//        UIBezierPath *path = [UIBezierPath bezierPath];
//        [path setLineWidth:3.0];
//        
//        CGPoint startingPoint = CGPointMake([self pointOnXAxisForColumn:0 inRect:rect],
//                                            [self pointOnYAxis:points[0] inDataSet:points inRect:rect]);
//        [path moveToPoint:startingPoint];
//        
//        for (int i = 1; i < [points count]; i++) {
//            CGPoint point = CGPointMake([self pointOnXAxisForColumn:i inRect:rect],
//                                        [self pointOnYAxis:points[i] inDataSet:points inRect:rect]);
//            [path addLineToPoint:point];
//        }
//        
//        [path stroke];
//    }
}

- (void)drawGraphLinesinRect:(CGRect)rect withContext:(CGContextRef)context {
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    
    CGFloat startX = [self actualGraphLeftRightMargin];
    CGFloat endX = rect.size.width - [self actualGraphLeftRightMargin];

    [linePath moveToPoint:CGPointMake(startX, self.actualGraphTopMargin)];
    [linePath moveToPoint:CGPointMake(endX, self.actualGraphTopMargin)];
    
    [linePath moveToPoint:CGPointMake(startX, rect.size.height / 2.0)];
    [linePath moveToPoint:CGPointMake(endX, rect.size.height / 2.0)];
    
    [linePath moveToPoint:CGPointMake(startX, self.actualGraphBottomMargin)];
    [linePath moveToPoint:CGPointMake(endX, self.actualGraphBottomMargin)];
    
    [[UIColor colorWithWhite:1.0 alpha:0.5] setStroke];
    [linePath setLineWidth:1.0];
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
    
    // Return early if there's no points to plot
    if (!_needsDataPointsDisplay || [_dataPoints count] == 0) {
        return;
    }
    _needsDataPointsDisplay = NO;
    
    CGContextSaveGState(context);
    [self drawGraphLinesinRect:rect withContext:context];
    CGContextRestoreGState(context);
    
    // Draw graph
    CGContextSaveGState(context);
    [self plotDataPoints:_dataPoints onGraphInRect:rect withContext:context];
    CGContextRestoreGState(context);
}

@end
