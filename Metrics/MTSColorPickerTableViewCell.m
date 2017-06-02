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

// Cached properties when determining color in location
@property (nonatomic) CGColorSpaceRef deviceColorSpace;
@property (nonatomic) NSArray <UIColor *> *gradientColors;

- (UIColor *)colorFromLocation:(CGPoint)location inRect:(CGRect)rect;

@end

@implementation MTSColorPickerTableViewCell

- (NSSortDescriptor *)touchesSortDescriptor {
    if (!_touchesSortDescriptor) {
        _touchesSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    }
    return _touchesSortDescriptor;
}

- (CGColorSpaceRef)deviceColorSpace {
    if (!_deviceColorSpace) {
        _deviceColorSpace = CGColorSpaceCreateDeviceRGB();
    }
    return _deviceColorSpace;
}

- (NSArray <UIColor *> *)gradientColors {
    if (!_gradientColors) {
        _gradientColors = @[
                            [UIColor redColor],
                            [UIColor orangeColor],
                            [UIColor yellowColor],
                            [UIColor greenColor],
                            [UIColor cyanColor],
                            [UIColor blueColor],
                            [UIColor magentaColor],
                            [UIColor purpleColor]
                            ];
    }
    return _gradientColors;
}

- (void)dealloc {
    CGColorSpaceRelease(_deviceColorSpace);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setOriginalSwatchFrame:[self colorSwatchView].frame];
    [self setColorSelectionEnabled:YES];
}

- (void)setColorSelectionEnabled:(BOOL)colorSelectionEnabled {
    _colorSelectionEnabled = colorSelectionEnabled;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (![self isColorSelectionEnabled]) {
        return;
    }
    
    [self setSwatchFrame:[self bounds] andLabelAlpha:0.0];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    if (![self isColorSelectionEnabled]) {
        return;
    }
    
    UITouch *touch = [[touches sortedArrayUsingDescriptors:@[[self touchesSortDescriptor]]] firstObject];
    CGPoint location = [touch locationInView:self];
    
    UIColor *interpolatedColor = [self colorFromLocation:location inRect:[self bounds]];
    
    [UIView animateWithDuration:0.25 animations:^{
        [[self colorSwatchView] setBackgroundColor:interpolatedColor];
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (![self isColorSelectionEnabled]) {
        return;
    }
    
    [self setSwatchFrame:[self originalSwatchFrame] andLabelAlpha:1.0];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    if (![self isColorSelectionEnabled]) {
        return;
    }
    
    [self setSwatchFrame:[self originalSwatchFrame] andLabelAlpha:1.0];
}

- (void)setSwatchFrame:(CGRect)frame andLabelAlpha:(CGFloat)alpha {
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [[self colorSwatchView] setFrame:frame];
                         [[self textLabel] setAlpha:alpha];
                     } completion:NULL];
}

- (UIColor *)colorFromLocation:(CGPoint)location inRect:(CGRect)rect {
    NSInteger colorCount = [[self gradientColors] count];
    CGFloat interval = rect.size.width / (CGFloat)colorCount;
    
    CGFloat x = location.x;
    CGFloat start, end;
    NSInteger i;
    for (i = 0; i < colorCount; i++) {
        start = i * interval;
        end = (i + 1) * interval;
        
        if (start <= x && x <= end) {
            return [[self gradientColors] objectAtIndex:i];
        }
    }
    
    return nil;
}

@end
