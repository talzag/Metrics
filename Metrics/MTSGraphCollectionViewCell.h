//
//  GraphCollectionViewCell.h
//  Metrics
//
//  Created by Daniel Strokis on 2/5/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MetricsKit/MetricsKit.h>

@interface MTSGraphCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *graphTitleLabel;
@property (nonatomic) IBOutlet MTSGraphView *graphView;

@end
