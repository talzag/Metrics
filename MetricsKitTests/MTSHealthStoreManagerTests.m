//
//  MTSHealthStoreManagerTests.m
//  Metrics
//
//  Created by Daniel Strokis on 3/15/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import XCTest;

#import "MTSTestDataStack.h"
#import "MTSHealthStoreManager.h"

@interface MTSHealthStoreManagerTests : XCTestCase

@property MTSTestDataStack *dataStack;
@property HKHealthStore *healthStore;

@end

@implementation MTSHealthStoreManagerTests

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

- (void)testThatItRequestsReadAccessToHealthKit {
    XCTestExpectation *accessExpectation = [self expectationWithDescription:@"Test was granted access to HKHealthStore."];
    [MTSHealthStoreManager requestReadAccessForHealthStore:[self healthStore]
                                            completionHandler:^(BOOL success, NSError * _Nullable error) {
                                                XCTAssertTrue(success);
                                                [accessExpectation fulfill];
                                            }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail("Test was not granted read access to the health store in time: %@", error.localizedDescription);
        }
    }];
}

- (void)testThatItQueriesTheHealthStoreSuccessfully {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *start = [calendar startOfDayForDate:now];
    NSDate *end = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:start options:NSCalendarWrapComponents];
    
    XCTestExpectation *queryExpectation = [self expectationWithDescription:@"Health store query"];
    [MTSHealthStoreManager queryHealthStore:[self healthStore]
                            forQuantityType:HKQuantityTypeIdentifierActiveEnergyBurned
                                   fromDate:start
                                     toDate:end
                     usingCompletionHandler:^(NSArray<MTSQuantitySample *> * _Nullable samples) {
                         XCTAssertTrue([samples count] > 0);
                         [queryExpectation fulfill];
                     }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail("Error while attempting to query health store: %@", error.localizedDescription);
        }
    }];
}



@end
