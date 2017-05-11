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
    [graph setTopColor:[UIColor cyanColor]];
    [graph setBottomColor:[UIColor blueColor]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *start = [calendar startOfDayForDate:now];
    NSDate *end = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:start options:NSCalendarWrapComponents];
    
    NSSet *types = [NSSet setWithObjects: HKQuantityTypeIdentifierActiveEnergyBurned, HKQuantityTypeIdentifierBasalEnergyBurned, nil];
    NSDictionary *healthTypes = MTSQuantityTypeIdentifiers();
    NSMutableSet *queries = [NSMutableSet set];
    for (HKQuantityTypeIdentifier ident in types) {
        MTSQuery *query = [[MTSQuery alloc] initWithContext:context];
        [query setHealthKitTypeIdentifier:ident];
        [query setHealthTypeDisplayName:[healthTypes valueForKey:ident]];
        [queries addObject:query];
    }
    
    [graph setQueries:queries];
    [graph setStartDate:start];
    [graph setEndDate:end];
    
    [context save:nil];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Complete data flow test"];
    [graph executeQueriesWithHealthStore:[self healthStore] usingCompletionHandler:^(NSError * _Nullable error) {
        MTSRealCalorieValue([self healthStore], [graph startDate], [graph endDate], ^(double calories, NSError *error) {
            XCTAssertEqual([[graph queries] count], 2);
            XCTAssertEqual(calories, -100);
            
            CGSize size = CGSizeMake(150, 100);
            CGRect frame = CGRectMake(0.0, 0.0, size.width, size.height);
            UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
            MTSDrawGraph(UIGraphicsGetCurrentContext(), frame, graph);
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
    [graph setTopColor:[UIColor cyanColor]];
    [graph setBottomColor:[UIColor blueColor]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *start = [calendar startOfDayForDate:now];
    NSDate *end = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:start options:NSCalendarWrapComponents];
    
    NSSet *types = [NSSet setWithObjects: HKQuantityTypeIdentifierActiveEnergyBurned, HKQuantityTypeIdentifierBasalEnergyBurned, nil];
    NSDictionary *healthTypes = MTSQuantityTypeIdentifiers();
    NSMutableSet *queries = [NSMutableSet set];
    for (HKQuantityTypeIdentifier ident in types) {
        MTSQuery *query = [[MTSQuery alloc] initWithContext:context];
        [query setHealthKitTypeIdentifier:ident];
        [query setHealthTypeDisplayName:[healthTypes valueForKey:ident]];
        [queries addObject:query];
    }
    
    [graph setQueries:queries];
    [graph setStartDate:start];
    [graph setEndDate:end];
    
    NSError *error;
    [context save:&error];
    if (error) {
        XCTFail(@"Error saving context: %@", error.description);
    }

    graph = nil;
    queries = nil;
    
    NSManagedObjectContext *newContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [newContext setPersistentStoreCoordinator:[context persistentStoreCoordinator]];
    context = nil;
    
    NSFetchRequest *queryFetch = [MTSQuery fetchRequest];
    NSArray <MTSQuery *>*queryFetchResults = [newContext executeFetchRequest:queryFetch error:nil];
    XCTAssertEqual([queryFetchResults count], 2);
    XCTAssertTrue([[queryFetchResults firstObject] isKindOfClass:[MTSQuery class]]);
    
    
    NSFetchRequest *graphFetch = [MTSGraph fetchRequest];
    NSArray <MTSGraph *>* results = [newContext executeFetchRequest:graphFetch error:nil];
    MTSGraph *fetchedGraph = [results firstObject];
    XCTAssertNotNil(fetchedGraph);
    XCTAssertEqualObjects([fetchedGraph topColor], [UIColor cyanColor]);
    XCTAssertEqualObjects([fetchedGraph bottomColor], [UIColor blueColor]);
    XCTAssertEqualObjects([[queryFetchResults firstObject] graph], fetchedGraph);
    
    NSComparator configComparator = ^NSComparisonResult(MTSQuery *  _Nonnull obj1, MTSQuery *  _Nonnull obj2) {
        return [[obj1 healthKitTypeIdentifier] compare:[obj2 healthKitTypeIdentifier]];
    };
    
    NSArray <MTSQuery *> *sortedA = [queryFetchResults sortedArrayUsingComparator:configComparator];
    NSArray <MTSQuery *> *sortedB = [[[fetchedGraph queries] allObjects] sortedArrayUsingComparator:configComparator];
    
    XCTAssertEqualObjects([[sortedA firstObject] objectID], [[sortedB firstObject] objectID]);
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
    
    NSManagedObjectContext *moc = [[self dataStack] managedObjectContext];
    MTSGraph *graph = [[MTSGraph alloc] initWithContext:moc];
    
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self measureBlock:^{
        MTSDrawGraph(context, rect, graph);
    }];
    
    UIGraphicsEndImageContext();
}

- (void)testGraphDrawingWithEmptyDataSet {
    CGSize size = CGSizeMake(200, 150);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    NSManagedObjectContext *moc = [[self dataStack] managedObjectContext];
    MTSGraph *graph = [[MTSGraph alloc] initWithContext:moc];
    
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self measureBlock:^{
        MTSDrawGraph(context, rect, graph);
    }];
    
    UIGraphicsEndImageContext();
}

- (void)testGraphDrawingWithGradients {
    CGSize size = CGSizeMake(200, 150);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    NSManagedObjectContext *moc = [[self dataStack] managedObjectContext];
    MTSGraph *graph = [[MTSGraph alloc] initWithContext:moc];
    
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *cyan = [UIColor cyanColor];
    UIColor *blue = [UIColor blueColor];
    
    [graph setTopColor:cyan];
    [graph setBottomColor:blue];
    
    [self measureBlock:^{
        MTSDrawGraph(context, rect, graph);
    }];
    
    UIGraphicsEndImageContext();
}

@end
