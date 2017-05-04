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
@import UIKit;

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

- (void)testGraphUsageWorkflow {
    NSManagedObjectContext *context = [[self dataStack] managedObjectContext];
    MTSGraph *graph = [[MTSGraph alloc] initWithContext:context];
    
    [graph setTitle:@"Test Graph"];
    
    MTSColorBox *blueBox = [[MTSColorBox alloc] initWithCGColorRef:[[UIColor blueColor] CGColor]];
    MTSColorBox *cyanBox = [[MTSColorBox alloc] initWithCGColorRef:[[UIColor cyanColor] CGColor]];
    [graph setTopColor:cyanBox];
    [graph setBottomColor:blueBox];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *start = [calendar startOfDayForDate:now];
    NSDate *end = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:start options:NSCalendarWrapComponents];
    
    MTSQuery *query = [[MTSQuery alloc] initWithContext:context];
    NSSet *types = [NSSet setWithObjects: HKQuantityTypeIdentifierActiveEnergyBurned, HKQuantityTypeIdentifierBasalEnergyBurned, nil];
    [query setQuantityTypes:types];
    [query setStartDate:start];
    [query setEndDate:end];
    [graph setQuery:query];
    
    [context save:nil];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Complete data flow test"];
    [graph executeQueryWithHealthStore:[self healthStore] usingCompletionHandler:^(NSArray * _Nullable results, NSError * _Nullable error) {
        MTSRealCalorieValue([self healthStore], [[graph query] startDate], [[graph query] endDate], ^(double calories, NSError *error) {
            XCTAssertEqual([results count], 2);
            XCTAssertEqual(calories, -100);
            
            CGSize size = CGSizeMake(150, 100);
            CGRect frame = CGRectMake(0.0, 0.0, size.width, size.height);
            UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
            MTSDrawGraph(UIGraphicsGetCurrentContext(), frame, results, [[graph topColor] color], [[graph bottomColor] color]);
            UIGraphicsEndImageContext();
            
            [expectation fulfill];
        });

    }];
    
    [self waitForExpectationsWithTimeout:15 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Test timed out waiting for graph completion handlers.");
        }
    }];
}

- (void)testThatObjectsSaveCorrectly {
    NSManagedObjectContext *context = [[self dataStack] managedObjectContext];
    MTSGraph *graph = [[MTSGraph alloc] initWithContext:context];
    
    [graph setTitle:@"Test Graph"];
    
    MTSColorBox *blueBox = [[MTSColorBox alloc] initWithCGColorRef:[[UIColor blueColor] CGColor]];
    MTSColorBox *cyanBox = [[MTSColorBox alloc] initWithCGColorRef:[[UIColor cyanColor] CGColor]];
    [graph setTopColor:cyanBox];
    [graph setBottomColor:blueBox];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *start = [calendar startOfDayForDate:now];
    NSDate *end = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:start options:NSCalendarWrapComponents];
    
    MTSQuery *query = [[MTSQuery alloc] initWithContext:context];
    NSSet *types = [NSSet setWithObjects: HKQuantityTypeIdentifierActiveEnergyBurned, HKQuantityTypeIdentifierBasalEnergyBurned, nil];
    [query setQuantityTypes:types];
    [query setStartDate:start];
    [query setEndDate:end];
    [graph setQuery:query];
    
    [context save:nil];
    
    NSManagedObjectID *queryID = [query objectID];
    query = nil;
    
    NSFetchRequest *queryFetch = [MTSQuery fetchRequest];
    [queryFetch setPredicate:[NSPredicate predicateWithFormat:@"objectID == %@", queryID]];
    NSArray *fetchResults = [context executeFetchRequest:queryFetch error:nil];
    XCTAssertEqual([fetchResults count], 1);
    XCTAssertTrue([[fetchResults firstObject] isKindOfClass:[MTSQuery class]]);
    XCTAssertEqualObjects([[fetchResults firstObject] startDate], start);
    XCTAssertEqualObjects([[fetchResults firstObject] endDate], end);
    XCTAssertEqualObjects([[fetchResults firstObject] graph], graph);
    
    NSManagedObjectID *objectID = [graph objectID];
    graph = nil;
    
    MTSGraph *fetchedGraph = [context objectWithID:objectID];
    XCTAssertEqualObjects([fetchedGraph topColor], cyanBox);
    XCTAssertEqualObjects([fetchedGraph bottomColor], blueBox);
    XCTAssertEqualObjects([fetchedGraph query], [fetchResults firstObject]);
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
        MTSDrawGraph(context, rect, testSet, NULL, NULL);
    }];
    
    UIGraphicsEndImageContext();
}

- (void)testGraphDrawingWithEmptyDataSet {
    CGSize size = CGSizeMake(200, 150);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    NSDictionary *testData = @{
                               MTSGraphDataPointsKey: @[]
                               };
    NSArray *testSet = [NSArray arrayWithObject:testData];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self measureBlock:^{
        MTSDrawGraph(context, rect, testSet, NULL, NULL);
    }];
    
    UIGraphicsEndImageContext();
}

- (void)testGraphDrawingWithGradients {
    CGSize size = CGSizeMake(200, 150);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    NSDictionary *testData = @{
                               MTSGraphDataPointsKey: @[]
                               };
    NSArray *testSet = [NSArray arrayWithObject:testData];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef cyan = [[UIColor cyanColor] CGColor];
    CGColorRef blue = [[UIColor blueColor] CGColor];
    
    [self measureBlock:^{
        MTSDrawGraph(context, rect, testSet, cyan, blue);
    }];
    
    UIGraphicsEndImageContext();
}

@end
