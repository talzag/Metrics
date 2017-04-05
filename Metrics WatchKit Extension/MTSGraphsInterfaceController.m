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
    HKHealthStore *store = [HKHealthStore new];
    [graph setHealthStore:store];
    
    CGRect screen = [[WKInterfaceDevice currentDevice] screenBounds];
    CGSize screenSize = screen.size;
    
    UIGraphicsBeginImageContextWithOptions(screenSize, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextRetain(context);
    
    
    NSDictionary *testData = @{
                               MTSGraphDataPointsKey: @[@0, @75, @25, @50, @100, @50, @75, @25, @0]
                               };
    NSSet *testSet = [NSSet setWithObject:testData];
    MTSDrawGraph(context, screen, testSet);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    [[self graphInterfaceImage] setImage:image];
    
    [graph executeQueryWithCompletionHandler:^(NSArray * _Nullable results, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSSet *dataPoints = [graph graphDataFromQueryResults:results];
                if (dataPoints) {
                    MTSDrawGraph(context, screen, dataPoints);
                }
            }
            
            CGContextRelease(context);
            UIGraphicsEndImageContext();
        });
    }];
}

@end
