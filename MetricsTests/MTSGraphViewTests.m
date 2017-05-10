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

//- (void)testThatItEncodesCorrectly {
//    [[self graphView] setTopColor:[UIColor redColor]];
//    [[self graphView] setBottomColor:[UIColor grayColor]];
//    [[self graphView] setXAxisTitle:@"X Axis Title for Encoding"];
//    [[self graphView] setYAxisTitle:@"Y axis title for encoding"];
//    [[self graphView] setDataPoints:@[]];
//    
//    NSKeyedArchiver *aCoder = [NSKeyedArchiver new];
//    [[self graphView] encodeWithCoder:aCoder];
//    
//    NSData *data = [aCoder encodedData];
//    NSKeyedUnarchiver *aDecoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//    MTSGraphView *decoded = [[MTSGraphView alloc] initWithCoder:aDecoder];
//    
//    XCTAssertEqualObjects([decoded topColor], [UIColor redColor]);
//    XCTAssertEqualObjects([decoded bottomColor], [UIColor grayColor]);
//    XCTAssertTrue([[decoded xAxisTitle] isEqualToString:@"X Axis Title for Encoding"], @"Actual decoded title: %@", [decoded xAxisTitle]);
//    XCTAssertTrue([[decoded yAxisTitle] isEqualToString:@"Y axis title for encoding"], @"Actual decoded title: %@", [decoded yAxisTitle]);
//}

- (void)testGraphDrawingPerformance {
    UIGraphicsBeginImageContext([self graphView].frame.size);
    
    [self measureBlock:^{
        [[self graphView] drawRect:[self graphView].frame];
    }];
    
    UIGraphicsEndImageContext();
}

- (void)testBackgroundDrawingPerformance {
    UIGraphicsBeginImageContext([self graphView].frame.size);
    
    [self measureBlock:^{
        [[self graphView] drawRect:[self graphView].frame];
    }];
    
    UIGraphicsEndImageContext();
}

@end
