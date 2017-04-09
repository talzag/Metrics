//
//  MetricsKitTests.m
//  MetricsKitTests
//
//  Created by Daniel Strokis on 3/14/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import XCTest;
@import CoreData;
@import HealthKit;

#import "MetricsKit.h"
#import "MTSTestDataStack.h"

@interface MetricsKitTests : XCTestCase

@property MTSTestDataStack *dataStack;
@property HKHealthStore *healthStore;

@end

@implementation MetricsKitTests

- (void)setUp {
    [super setUp];
    [self setDataStack:[MTSTestDataStack new]];
    [self setHealthStore:[HKHealthStore new]];
    
    XCTestExpectation *writeExpectation = [self expectationWithDescription:@"Mock data written"];
    [[self dataStack] insertMockHealthDataIntoHealthStore:[self healthStore] completionHandler:^(BOOL success, NSError * _Nullable error) {
        [writeExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error waiting for mock data to be written to health store.");
        }
    }];
}

- (void)tearDown {
    XCTestExpectation *deletExpectation = [self expectationWithDescription:@"Mock data deleted"];
    [[self dataStack] deleteMockDataFromHealthStore:[self healthStore] withCompletionHandler:^{
        [deletExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error waiting for mock data to be deleted from health store");
        }
    }];
    
    [self setDataStack:nil];
    [self setHealthStore:nil];
    
    [super tearDown];
}

- (void)testThatRealCalorieValueIsCalculated {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *start = [calendar startOfDayForDate:now];
    NSDate *end = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:start options:NSCalendarWrapComponents];
    
    XCTestExpectation *caloriesExpectation = [self expectationWithDescription:@"Real calories calculated"];
    MTSRealCalorieValue([self healthStore], start, end, ^(double calories, NSError *error) {
        XCTAssertEqual(calories, -100);
        
        [caloriesExpectation fulfill];
    });
    
    
    [self waitForExpectationsWithTimeout:15 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error waiting for real calorie count to be calculated.");
        }
    }];
}

- (void)testGraphDrawingPerformance {
    CGSize size = CGSizeMake(200, 150);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    NSDictionary *testData = @{
                               MTSGraphDataPointsKey: @[@0, @75, @25, @50, @100, @50, @75, @25, @0]
                               };
   NSArray *testSet = [NSArray arrayWithObject:testData];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self measureBlock:^{
        MTSDrawGraph(context, rect, testSet);
    }];
    
    UIGraphicsEndImageContext();
}

@end
