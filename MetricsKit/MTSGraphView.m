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

- (void)setDataPoints:(NSArray <MTSQueryDataConfiguration *> *)dataPoints {
    _dataPoints = dataPoints;
    
    [self setNeedsDisplay];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSData *xTitleData = [aDecoder decodeObjectForKey:@"xAxisTitle"];
        _xAxisTitle = [[NSString alloc] initWithData:xTitleData encoding:NSUTF8StringEncoding];
        
        NSData *yTitleData = [aDecoder decodeObjectForKey:@"yAxisTitle"];
        _yAxisTitle = [[NSString alloc] initWithData:yTitleData encoding:NSUTF8StringEncoding];
        
        _topColor = [aDecoder decodeObjectForKey:@"topColor"];
        _bottomColor = [aDecoder decodeObjectForKey:@"bottomColor"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];

    NSData *xAxisData = [_xAxisTitle dataUsingEncoding:NSUTF8StringEncoding];
    [aCoder encodeObject:xAxisData forKey:@"xAxisTitle"];
    
    NSData *yAxisData = [_yAxisTitle dataUsingEncoding:NSUTF8StringEncoding];
    [aCoder encodeObject:yAxisData forKey:@"yAxisTitle"];
    
    [aCoder encodeObject:_topColor forKey:@"topColor"];
    [aCoder encodeObject:_bottomColor forKey:@"bottomColor"];
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
