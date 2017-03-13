//
//  MTSGraphViewTests.m
//  Metrics
//
//  Created by Daniel Strokis on 3/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MTSGraphView+Methods.h"

@interface MTSGraphViewTests : XCTestCase

@property MTSGraphView *graphView;
@property NSSet <NSDictionary <NSString *, id> *> *testData;

@end

/**
 These tests are really just for me to make sure that my math is correct.
 */
@implementation MTSGraphViewTests

- (void)setUp {
    [super setUp];
    
    NSDictionary <NSString *, id> *testDataDictionary = @{
                                                          MTSGraphDataPointsKey: @[@0, @25, @50, @75, @100, @75, @50, @25, @0]
                                                          };
    NSSet *testDataSet = [NSSet setWithObject:testDataDictionary];
    [self setTestData:testDataSet];
    
    CGRect frame = CGRectMake(0, 0, 300, 200);
    MTSGraphView *view = [[MTSGraphView alloc] initWithFrame:frame];
    [self setGraphView:view];
    [[self graphView] setDataPoints:testDataSet];
}

- (void)tearDown {
    [self setGraphView:nil];
    [self setTestData:nil];
    
    [super tearDown];
}

- (void)testActualGraphTopMargin {
    // 200 * 0.15 = 30
    XCTAssertEqual(30, [[self graphView] actualGraphTopMargin], @"Default value for actualGraphTopMargin should be 30");
}

- (void)testActualGraphBottomMargin {
    // 200 * 0.15 = 30
    XCTAssertEqual(30, [[self graphView] actualGraphBottomMargin], @"Default value for actualGraphBottomMargin should be 30");
}

- (void)testActualGraphHeight {
    // 200 - 30 = 170
    XCTAssertEqual(170, [[self graphView] actualGraphHeight], @"Default value for actualGraphHeight should be 170");
}

- (void)testActualGraphLeftRightMargin {
    // 300 * 0.05 = 15
    XCTAssertEqual(15, [[self graphView] actualGraphLeftRightMargin], @"Default value for actualGraphLeftRightMargin should be 15");
}

- (void)testActualGraphWidth {
    // 300 - 30 = 270
    XCTAssertEqual(270, [[self graphView] actualGraphWidth], @"Default value for actualGraphWidth should be 270");
}

- (void)testColumnWidth {
    // 300 - 15 * 2 = 270
    XCTAssertEqual(270, [[self graphView] columnWidthForArraySize:0]);
    
    // 300 - 15 * 2 = 270 / 1 = 270
    XCTAssertEqual(270, [[self graphView] columnWidthForArraySize:1]);
    
    // 300 - 15 * 2 = 270 / 2 = 135
    XCTAssertEqual(135, [[self graphView] columnWidthForArraySize:2]);
    
    // 300 - 15 * 2 = 270 / 3 = 90
    XCTAssertEqual(90, [[self graphView] columnWidthForArraySize:3]);
}

- (void)testPositionOnXAxis {
    NSArray *array = [[[[self testData] allObjects] firstObject] objectForKey:MTSGraphDataPointsKey];
    NSUInteger size = [array count];
    
    // 30 * 0 + 15 = 15
    XCTAssertEqual(15, [[self graphView] positionOnXAxisForValueAtIndex:0 fromArrayOfSize:size]);
    
    // 30 * 1 + 15 = 45
    XCTAssertEqual(45, [[self graphView] positionOnXAxisForValueAtIndex:1 fromArrayOfSize:size]);
    
    // 30 * 2 + 15 = 75
    XCTAssertEqual(75, [[self graphView] positionOnXAxisForValueAtIndex:2 fromArrayOfSize:size]);
}

- (void)testPositionOnYAxis {
    NSArray <NSNumber *>*array = [[[[self testData] allObjects] firstObject] objectForKey:MTSGraphDataPointsKey];
    __block NSNumber *maxNum = @0;
    [array enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        maxNum = MAX(maxNum, obj);
    }];
    CGFloat max = [maxNum doubleValue];
    // max == 100
    
    // should return 0
    XCTAssertEqual(0, [[self graphView] positionOnYAxisForValue:0 scaledForMaxValue:max]);
    
    // 170 - 30 = 140
    // 25 / 100 = 0.25
    // 170  - 0.25 * 140 = 135
    XCTAssertEqual(135, [[self graphView] positionOnYAxisForValue:25 scaledForMaxValue:max]);
    
    // 170 - 30 = 140
    // 50 / 100 = 0.5
    // 170 - 0.5 * 140 = 100
    XCTAssertEqual(100, [[self graphView] positionOnYAxisForValue:50 scaledForMaxValue:max]);
}

- (void)testGraphDrawingPerformance {
    [self measureBlock:^{
        [[self graphView] drawRect:[self graphView].frame];
    }];
}

@end
