//
//  MTSGraphTableViewCell.m
//  Metrics
//
//  Created by Daniel Strokis on 5/3/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphTableViewCell.h"

@interface MTSGraphTableViewCell ()

@end

@implementation MTSGraphTableViewCell

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [[self graphView] setNeedsDisplay];
}

@end
