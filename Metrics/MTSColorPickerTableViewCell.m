//
//  MTSColorPickerTableViewCell.m
//  Metrics
//
//  Created by Daniel Strokis on 4/25/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSColorPickerTableViewCell.h"

@implementation MTSColorPickerTableViewCell

- (void)setSwatchColor:(UIColor *)swatchColor {
    _swatchColor = swatchColor;
    // update colorSwatchView
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    // animage swatch over rest of cell
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    // track color across view ltr
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    // close color swatch view
    // set _swatchColor
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    // close color swatch view
}

@end
