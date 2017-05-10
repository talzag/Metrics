//
//  GraphView.m
//  Metrics
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphView.h"

@implementation MTSGraphView


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];

}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    MTSDrawGraph(context, rect, [self graph]);
}

@end
