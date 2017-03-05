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
    
}

- (void)testTopColor {
    
}

- (void)testBottomColor {
    
}

- (void)testGraphTopMarginPercent {
    
}

- (void)testGraphBottomMarginPercent {
    
}

- (void)testGraphLeftRightMarginPercent {
    
}

- (void)testActualGraphHeight {
    
}

- (void)testActualGraphWidth {
    
}

- (void)testActualGraphTopMargin {
    
}

- (void)testActualGraphBottomMargin {
    
}

- (void)testActualGraphLeftRightMargin {
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
