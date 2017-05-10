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

@property (nonatomic) MTSGraph *graph;

@end
