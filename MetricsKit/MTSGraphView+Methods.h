//
//  MTSGraph_Methods.h
//  Metrics
//
//  Created by Daniel Strokis on 3/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphView.h"

@interface MTSGraphView ()

@property (nonatomic) BOOL needsDataPointsDisplay;

@property (nonatomic) CGFloat graphTopMarginPercent;
@property (nonatomic) CGFloat graphBottomMarginPercent;
@property (nonatomic) CGFloat graphLeftRightMarginPercent;

@property (readonly) CGFloat actualGraphHeight;
@property (readonly) CGFloat actualGraphWidth;
@property (readonly) CGFloat actualGraphTopMargin;
@property (readonly) CGFloat actualGraphBottomMargin;
@property (readonly) CGFloat actualGraphLeftRightMargin;

//- (CGFloat)columnWidthForArraySize:(NSUInteger)numberOfElements;
//- (CGFloat)positionOnXAxisForValueAtIndex:(int)index fromArrayOfSize:(NSInteger)size;
//- (CGFloat)positionOnYAxisForValue:(CGFloat)value scaledForMaxValue:(CGFloat)maxValue;

@end
