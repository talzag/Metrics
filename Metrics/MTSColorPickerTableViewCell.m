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
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setSwatchFrame:[self bounds] andLabelAlpha:0.0];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[touches sortedArrayUsingDescriptors:@[[self touchesSortDescriptor]]] firstObject];
    CGPoint location = [touch locationInView:self];
    
    UIColor *interpolatedColor = [self colorFromLocation:location inRect:[self bounds]];
    [[self colorSwatchView] setBackgroundColor:interpolatedColor];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self setSwatchFrame:[self originalSwatchFrame] andLabelAlpha:1.0];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
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
    CGFloat interval = rect.size.width / (CGFloat)[[self gradientColors] count];
    
    size_t numCom = CGColorGetNumberOfComponents([[[self gradientColors] firstObject] CGColor]);
    CGFloat * _Nullable c1 = NULL;
    CGFloat * _Nullable c2 = NULL;
    CGFloat start, end, x = location.x;
    
    
    NSInteger i;
    for (i = 0; i < [[self gradientColors] count]; i++) {
        start = i * interval;
        end = (i + 1) * interval;
        
        CGColorRef startColor = [[[self gradientColors] objectAtIndex:i] CGColor];
        CGColorRef endColor = [[[self gradientColors] objectAtIndex:(i + 1)] CGColor];
        if (start <= x && x <= end) {
            c1 = (CGFloat * _Nullable)CGColorGetComponents(startColor);
            c2 = (CGFloat * _Nullable)CGColorGetComponents(endColor);
            break;
        }
    }
    
    if (numCom < 3 || !c1 || !c2) {
        return [[self colorSwatchView] backgroundColor];
    }
    
    CGFloat percenct = location.x / CGRectGetMaxX(rect);
    CGFloat components[4];
    
    NSInteger j;
    for (j = 0; j < numCom; j++) {
        components[j] =  *(c1 + j) + percenct * (*(c2 + j) - *(c1 + j));
    }
    components[3] = 1.0;
    
    CGColorRef colorRef = CGColorCreate([self deviceColorSpace], components);
    UIColor *color = [UIColor colorWithCGColor:colorRef];
    CGColorRelease(colorRef);
    
    return color;
}

@end
