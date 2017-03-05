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

@implementation MTSGraphViewTests

- (void)setUp {
    [super setUp];
    
    NSDictionary <NSString *, id> *testDataDictionary = @{
                                                          MTSGraphDataPointsKey: @[]
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

- (void)testDrawIntermediateLines {
    XCTAssertTrue([[self graphView] drawIntermediateLines], @"Default value for drawIntermediateLines should be YES");
}

- (void)testTopColor {
    XCTAssertEqual([UIColor whiteColor], [[self graphView] topColor], @"Default value for topColor should be [UIColor whiteColor]");
}

- (void)testBottomColor {
    XCTAssertEqual([UIColor whiteColor], [[self graphView] bottomColor], @"Default value for bottomColor should be [UIColor whiteColor]");
}

- (void)testGraphTopMarginPercent {
    XCTAssertEqual(0.15, [[self graphView] graphTopMarginPercent], @"Default value for graphTopMarginPercent should be 0.15");
}

- (void)testGraphBottomMarginPercent {
    XCTAssertEqual(0.15, [[self graphView] graphBottomMarginPercent], @"Default value for graphBottomMarginPercent should be 0.15");
}

- (void)testGraphLeftRightMarginPercent {
    XCTAssertEqual(0.05, [[self graphView] graphLeftRightMarginPercent], @"Default value for graphLeftRightMarginPercent should be 0.05");
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

- (void)XtestColumnWidth {
    
}

- (void)XtestPositionOnXAxis {
    
}

- (void)XtestPositionOnYAxis {
    
}

- (void)XtestGraphDrawingPerformance {
    [self measureBlock:^{
    
    }];
}

@end
