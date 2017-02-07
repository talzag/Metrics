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

@property NSUInteger graphTopMargin;
@property NSUInteger graphBottomMargin;
@property NSUInteger graphLeftRightMargin;

@end

@implementation MTSGraphView

- (instancetype)init {
    self = [super init];
    if (self) {
        _topColor = [UIColor cyanColor];
        _bottomColor = [UIColor blueColor];
        _needsDataPointsDisplay = NO;
        _dataPoints = [NSArray array];
        _graphTopMargin = _graphBottomMargin = 30.0;
        _graphLeftRightMargin = 20.0;
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
        _graphTopMargin = _graphBottomMargin = 30.0;
        _graphLeftRightMargin = 20.0;
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
        _graphTopMargin = _graphBottomMargin = 30.0;
        _graphLeftRightMargin = 20.0;
    }
    return self;
}

- (void)setDataPoints:(NSArray<NSArray<id> *> *)dataPoints {
    _dataPoints = dataPoints;
    
//    _needsDataPointsDisplay = [[_dataPoints objectForKey:@"x"] count] + [[_dataPoints objectForKey:@"y"] count] > 0;
    
    if (_needsDataPointsDisplay) {
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:25.0];
    [clipPath addClip];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSArray *colors = @[(id)[_topColor CGColor], (id)[_bottomColor CGColor]];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, NULL);
    CGPoint startPoint = CGPointZero;
    CGPoint endpoint = CGPointMake(0.0, rect.size.height);
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endpoint, kCGGradientDrawsBeforeStartLocation);
    
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    if (!_needsDataPointsDisplay || [_dataPoints count] == 0) {
        return;
    }
    _needsDataPointsDisplay = NO;
    
    
    [[UIColor whiteColor] set];
    for (NSArray *points in [self dataPoints]) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path setLineWidth:3.0];
        CGPoint startingPoint = CGPointMake([self pointOnXAxisForColumn:0 inRect:rect],
                                            [self pointOnYAxis:points[0] inDataSet:points inRect:rect]);
        [path moveToPoint:startingPoint];
        
        for (int i = 1; i < [points count]; i++) {
            CGPoint point = CGPointMake([self pointOnXAxisForColumn:i inRect:rect],
                                        [self pointOnYAxis:points[i] inDataSet:points inRect:rect]);
            [path addLineToPoint:point];
        }
        [path stroke];
    }
}

- (CGFloat) xAxisColumnWidthForNumberOfDataPoints: (NSUInteger)numberOfDataPoints {
    return (self.frame.size.width - ([self graphLeftRightMargin] * 2)) / numberOfDataPoints;
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

@end
