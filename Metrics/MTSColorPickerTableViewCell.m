//
//  MTSColorPickerTableViewCell.m
//  Metrics
//
//  Created by Daniel Strokis on 4/25/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSColorPickerTableViewCell.h"

@interface MTSColorPickerTableViewCell ()

@property (nonatomic) CGRect originalSwatchFrame;

@end

@implementation MTSColorPickerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setOriginalSwatchFrame:[self colorSwatchView].frame];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setColorSwatchViewFrame:[self frame]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self setColorSwatchViewFrame:[self originalSwatchFrame]];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self setColorSwatchViewFrame:[self originalSwatchFrame]];
}

- (void)setColorSwatchViewFrame:(CGRect)frame {
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [[self colorSwatchView] setFrame:frame];
                     } completion:NULL];
}

@end
