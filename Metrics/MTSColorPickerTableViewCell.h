//
//  MTSColorPickerTableViewCell.h
//  Metrics
//
//  Created by Daniel Strokis on 4/25/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTSColorPickerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *colorSwatchView;
@property (nonatomic, getter=isColorSelectionEnabled) BOOL colorSelectionEnabled;

@end
