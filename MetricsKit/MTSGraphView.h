//
//  GraphView.h
//  Metrics
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MetricsKit/MetricsKit.h>

IB_DESIGNABLE
@interface MTSGraphView : UIView <NSCoding>

@property (nonatomic) NSString *yAxisTitle;
@property (nonatomic) NSString *xAxisTitle;

@property (nonatomic) IBInspectable UIColor *topColor;
@property (nonatomic) IBInspectable UIColor *bottomColor;

@property (nonatomic) NSSet <MTSQueryDataConfiguration *> *dataPoints;

@end
