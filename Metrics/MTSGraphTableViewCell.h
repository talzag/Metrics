//
//  MTSGraphTableViewCell.h
//  Metrics
//
//  Created by Daniel Strokis on 5/3/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import UIKit;

#import <MetricsKit/MetricsKit.h>
#import "MTSGraphView.h"

@interface MTSGraphTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet MTSGraphView *graphView;

@end
