//
//  MTSGraphsInterfaceController.m
//  Metrics
//
//  Created by Daniel Strokis on 3/23/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphsInterfaceController.h"

@implementation MTSGraphsInterfaceController

- (void)awakeWithContext:(id)ctx {
    [super awakeWithContext:ctx];
    
    
}

- (void)willActivate {
    MTSGraph *graph = [[MTSGraph alloc] initWithContext:[self managedObjectContext]];
    
    
    CGRect screen = [[WKInterfaceDevice currentDevice] screenBounds];
    CGSize screenSize = screen.size;
    
    UIGraphicsBeginImageContextWithOptions(screenSize, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    MTSDrawGraph(graph, context, screen);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    [[self graphInterfaceImage] setImage:image];
    
    UIGraphicsEndImageContext();
}

@end
