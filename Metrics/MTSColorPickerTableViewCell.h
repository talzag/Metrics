//
//  MTSColorPickerTableViewCell.h
//  Metrics
//
//  Created by Daniel Strokis on 4/25/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTSColorPickerTableViewCell : UITableViewCell

@property (nonatomic) UIColor *swatchColor;
@property (weak, nonatomic) IBOutlet UIView *colorSwatchView;

@end
