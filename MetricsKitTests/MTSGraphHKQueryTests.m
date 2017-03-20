//
//  MTSGraphHKQueryTests.m
//  Metrics
//
//  Created by Daniel Strokis on 3/18/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import XCTest;
@import HealthKit;

#import "MTSGraph+HKQuery.h"
#import "MTSTestDataStack.h"

@interface MTSGraphHKQueryTests : XCTestCase

@property HKHealthStore *healthStore;
@property MTSTestDataStack *dataStack;
@property MTSGraph *graph;

@end

@implementation MTSGraphHKQueryTests

- (void)setUp {
    [super setUp];
    [self setDataStack:[MTSTestDataStack new]];
    [self setGraph:[[MTSGraph alloc] initWithContext:[[self dataStack] managedObjectContext]]];
    
    [self setHealthStore:[HKHealthStore new]];
    
    XCTestExpectation *writeAccessExpectation = [self expectationWithDescription:@"Write access granted"];
    XCTestExpectation *writeDataExpectation = [self expectationWithDescription:@"Mock health data written"];
    __weak MTSGraphHKQueryTests *weakSelf = self;
    [[self healthStore] requestAuthorizationToShareTypes:[[self dataStack] healthDataTypes]
                                               readTypes:nil
                                              completion:^(BOOL success, NSError * _Nullable error) {
                                                  if (success) {
                                                      [writeAccessExpectation fulfill];
                                                      
                                                      MTSGraphHKQueryTests *this = weakSelf;
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
    XCTAssertNil([[self graph] dataPoints]);
    [[self graph] setQuantityHealthTypeIdentifiers:[NSSet setWithObject:HKQuantityTypeIdentifierActiveEnergyBurned]];
    XCTestExpectation *dataExpectation = [self expectationWithDescription:@"Finished querying health store"];
    __weak MTSGraphHKQueryTests *weakSelf = self;
    [[self graph] populateGraphDataByQueryingHealthStore:[self healthStore] completionHandler:^(NSArray<__kindof HKSample *> * _Nullable samples) {
        if ([samples count]) {
            MTSGraphHKQueryTests *this = weakSelf;
            NSSet *data = [[this graph] dataPoints];
            XCTAssertNotNil(data);
            XCTAssert([data count] == 1);
            [dataExpectation fulfill];
        }
    }];
    
    [self waitForExpectationsWithTimeout:15 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error attempting to query health store for data.");
        }
    }];
}

@end
