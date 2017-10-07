//
//  MTSGraphHKQueryTests.m
//  Metrics
//
//  Created by Daniel Strokis on 3/18/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import XCTest;
@import HealthKit;

#import "MetricsKit.h"
#import "MTSTestDataStack.h"

@interface MTSGraphQueryableTests : XCTestCase

@property HKHealthStore *healthStore;
@property MTSTestDataStack *dataStack;
@property MTSGraph *graph;

@end

@implementation MTSGraphQueryableTests

- (void)setUp {
    [super setUp];
    [self setDataStack:[MTSTestDataStack new]];
    [self setGraph:[[MTSGraph alloc] initWithContext:[[self dataStack] managedObjectContext]]];
    
    [self setHealthStore:[HKHealthStore new]];
    
    XCTestExpectation *writeAccessExpectation = [self expectationWithDescription:@"Write access granted"];
    XCTestExpectation *writeDataExpectation = [self expectationWithDescription:@"Mock health data written"];
    __weak MTSGraphQueryableTests *weakSelf = self;
    [[self healthStore] requestAuthorizationToShareTypes:[[self dataStack] healthDataTypes]
                                               readTypes:nil
                                              completion:^(BOOL success, NSError * _Nullable error) {
                                                  if (success) {
                                                      [writeAccessExpectation fulfill];
                                                      
                                                      MTSGraphQueryableTests *this = weakSelf;
                                                      [[this dataStack] insertMockHealthDataIntoHealthStore:this.healthStore completionHandler:^(BOOL success, NSError * _Nullable error) {
                                                          if (success) {
                                                              [writeDataExpectation fulfill];
                                                          }
                                                      }];
                                                  }
                                              }];
    [self waitForExpectationsWithTimeout:15 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error attempting to write data to health store.");
        }
    }];
}

- (void)tearDown {
    XCTestExpectation *cleanUpExpectation = [self expectationWithDescription:@"Removed health data"];
    [[self dataStack] deleteMockDataFromHealthStore:[self healthStore] withCompletionHandler:^{
        [cleanUpExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error attempting to delete data from health store.");
        }
    }];
    
    [self setGraph:nil];
    [self setDataStack:nil];
    [self setHealthStore:nil];
    
    [super tearDown];
}

- (void)testThatItPopulatesDataPointsAfterQueryingHealthStore {
    NSManagedObjectContext *context = [[self dataStack] managedObjectContext];
    
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
    
    MTSGraph *graph = [[MTSGraph alloc] initWithContext:context];
    [graph setQueries:queries];
    [graph setStartDate:start];
    [graph setEndDate:end];
    
    [context save:nil];
    
    XCTestExpectation *queryExpectation = [self expectationWithDescription:@"Graph querying"];
    [graph executeQueriesWithHealthStore:[self healthStore] usingCompletionHandler:^(NSError * _Nullable error) {
        NSArray *queries = [[graph queries] allObjects];
        XCTAssertNotNil(queries);
        XCTAssertTrue([queries count] == 2);
        
        XCTAssertEqual([[[[queries firstObject] fetchedDataPoints] firstObject] integerValue] , 100);
        XCTAssertEqual([[[[queries lastObject] fetchedDataPoints] firstObject] integerValue] , 100);
        
        [queryExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:(60 * 60 * 24) handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error attempting to execute graphy query.");
        }
    }];
}

- (void)testThatItWillReturnAnErrorIfStartDateIsNull {
    NSManagedObjectContext *context = [[self dataStack] managedObjectContext];
    MTSGraph *graph = [[MTSGraph alloc] initWithContext:context];
    [graph setEndDate:[NSDate date]];
    [context save:nil];
    
    XCTestExpectation *queryExpectation = [self expectationWithDescription:@"Graph querying with nil query"];
    [graph executeQueriesWithHealthStore:[self healthStore] usingCompletionHandler:^(NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertEqualObjects([error domain], @"com.dstrokis.Metrics");
        XCTAssertEqual([error code], 1);
        
        [queryExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error attempting to execute graphy query.");
        }
    }];
}

- (void)testThatItWillReturnAnErrorIfEndDateIsNull {
    NSManagedObjectContext *context = [[self dataStack] managedObjectContext];
    MTSGraph *graph = [[MTSGraph alloc] initWithContext:context];
    [graph setStartDate:[NSDate date]];
    [context save:nil];
    
    XCTestExpectation *queryExpectation = [self expectationWithDescription:@"Graph querying with nil query"];
    [graph executeQueriesWithHealthStore:[self healthStore] usingCompletionHandler:^(NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertEqualObjects([error domain], @"com.dstrokis.Metrics");
        XCTAssertEqual([error code], 1);
        
        [queryExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error attempting to execute graphy query.");
        }
    }];
}

- (void)testThatItWillReturnAnErrorIfQueryIsNull {
    NSManagedObjectContext *context = [[self dataStack] managedObjectContext];
    
    MTSGraph *graph = [[MTSGraph alloc] initWithContext:context];
    [graph setStartDate:[NSDate date]];
    [graph setEndDate:[NSDate date]];
    
    [context save:nil];
    
    XCTestExpectation *queryExpectation = [self expectationWithDescription:@"Graph querying with nil query"];
    [graph executeQueriesWithHealthStore:[self healthStore] usingCompletionHandler:^(NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertEqualObjects([error domain], @"com.dstrokis.Metrics");
        XCTAssertEqual([error code], 2);
        
        [queryExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error attempting to execute graphy query.");
        }
    }];
}

- (void)testThatItWillReturnAnErrorIfHealthStoreIsNull {
    NSManagedObjectContext *context = [[self dataStack] managedObjectContext];
    
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
    
    MTSGraph *graph = [[MTSGraph alloc] initWithContext:context];
    [graph setQueries:queries];
    [graph setStartDate:start];
    [graph setEndDate:end];
    
    [context save:nil];
    HKHealthStore *healthStore = nil;
    
    XCTestExpectation *queryExpectation = [self expectationWithDescription:@"Graph querying with nil health store"];
    [graph executeQueriesWithHealthStore:healthStore usingCompletionHandler:^(NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertEqualObjects([error domain], @"com.dstrokis.Metrics");
        XCTAssertEqual([error code], 3);
        
        [queryExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error attempting to execute graphy query.");
        }
    }];
}

@end
