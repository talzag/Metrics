//
//  GraphView.h
//  Metrics
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface MTSGraphView : UIView

@property (strong, nonatomic) NSArray <NSArray <id>*> *dataPoints;

@property (strong, nonatomic) IBInspectable UIColor *topColor;
@property (strong, nonatomic) IBInspectable UIColor *bottomColor;
@property (weak) IBOutlet UILabel *titleLabel;

@end
