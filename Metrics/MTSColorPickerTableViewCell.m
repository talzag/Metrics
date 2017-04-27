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
@property (nonatomic) NSSortDescriptor *touchesSortDescriptor;

- (UIColor *)colorFromLocationInView:(CGPoint)location;

@end

@implementation MTSColorPickerTableViewCell

- (NSSortDescriptor *)touchesSortDescriptor {
    if (!_touchesSortDescriptor) {
        _touchesSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    }
    return _touchesSortDescriptor;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setOriginalSwatchFrame:[self colorSwatchView].frame];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [[self colorSwatchView] setFrame:[self bounds]];
                         [[self textLabel] setAlpha:0.0];
                     } completion:NULL];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[touches sortedArrayUsingDescriptors:@[[self touchesSortDescriptor]]] firstObject];
    CGPoint location = [touch locationInView:self];
    
    UIColor *interpolatedColor = [self colorFromLocationInView:location];
    [[self colorSwatchView] setBackgroundColor:interpolatedColor];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [[self colorSwatchView] setFrame:[self originalSwatchFrame]];
                         [[self textLabel] setAlpha:1.0];
                     } completion:NULL];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [[self colorSwatchView] setFrame:[self originalSwatchFrame]];
                         [[self textLabel] setAlpha:1.0];
                     } completion:NULL];
}

- (UIColor *)colorFromLocationInView:(CGPoint)location {
    // interpolate color from location.x
    
    return [[self colorSwatchView] backgroundColor];
}

@end
