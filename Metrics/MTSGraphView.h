//
//  GraphView.h
//  Metrics
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *MTSGraphLineColorKey;
extern NSString *MTSGraphDataPointsKey;

IB_DESIGNABLE
@interface MTSGraphView : UIView

@property (nonatomic) NSString *yAxisTitle;
@property (nonatomic) NSString *xAxisTitle;
@property (nonatomic) NSArray <NSDictionary <NSString *, id> *> *dataPoints;

@property (nonatomic) BOOL drawIntermediateLines;
@property (nonatomic) IBInspectable UIColor *topColor;
@property (nonatomic) IBInspectable UIColor *bottomColor;
@property (weak) IBOutlet UILabel *titleLabel;

@end
