//
//  GraphView.m
//  Metrics
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphView.h"

@implementation MTSGraphView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _topColor = [UIColor whiteColor];
        _bottomColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setDataPoints:(NSArray<NSDictionary<NSString *,id> *> *)dataPoints {
    _dataPoints = dataPoints;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSArray *data = [self dataPoints];
    
    CGColorRef top = NULL, bottom = NULL;
    
    if ([self topColor]) {
        top = [[self topColor] CGColor];
    }
    
    if ([self bottomColor]) {
        bottom = [[self bottomColor] CGColor];
    }
    
    MTSDrawGraph(context, rect, data, top, bottom);
}

@end
