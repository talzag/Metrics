//
//  GraphView.m
//  Metrics
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphView.h"
#import "MTSGraphView+Methods.h"

@implementation MTSGraphView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _topColor = [UIColor whiteColor];
        _bottomColor = [UIColor whiteColor];
        _needsDataPointsDisplay = NO;
        _dataPoints = [NSSet set];
        _graphTopMarginPercent = _graphBottomMarginPercent = 0.15;
        _graphLeftRightMarginPercent = 0.05;
        _drawIntermediateLines = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSDictionary *testData = @{
                               MTSGraphDataPointsKey: @[@0, @75, @25, @50, @100, @50, @75, @25, @0]
                               };
    NSSet *testSet = [NSSet setWithObject:testData];
    
    MTSDrawGraph(context, rect, testSet);
}

@end
