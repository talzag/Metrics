//
//  MTSGraphViewTests.m
//  Metrics
//
//  Created by Daniel Strokis on 3/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import XCTest;

#import "MTSGraphView.h"

@interface MTSGraphViewTests : XCTestCase

@property MTSGraphView *graphView;
@end

@implementation MTSGraphViewTests

- (void)setUp {
    [super setUp];
    
    CGRect frame = CGRectMake(0, 0, 300, 200);
    MTSGraphView *view = [[MTSGraphView alloc] initWithFrame:frame];
    
    [self setGraphView:view];
}

- (void)tearDown {
    [self setGraphView:nil];
    
    [super tearDown];
}

- (void)testDrawingPerformance {
    UIGraphicsBeginImageContext([self graphView].frame.size);
    
    [self measureBlock:^{
        [[self graphView] drawRect:[self graphView].frame];
    }];
    
    UIGraphicsEndImageContext();
}

@end
