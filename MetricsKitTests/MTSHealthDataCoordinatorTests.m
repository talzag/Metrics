//
//  MTSHealthDataCoordinatorTests.m
//  Metrics
//
//  Created by Daniel Strokis on 3/15/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import XCTest;

#import "MTSHealthDataCoordinator.h"

@interface MTSHealthDataCoordinatorTests : XCTestCase

@property MTSHealthDataCoordinator *coordinator;
@property HKHealthStore *healthStore;

@end

@implementation MTSHealthDataCoordinatorTests

- (void)setUp {
    [super setUp];
    
    [self setCoordinator:[MTSHealthDataCoordinator new]];
    
    [self setHealthStore:[HKHealthStore new]];
}

- (void)tearDown {
    [self setCoordinator:nil];
    [self setHealthStore:nil];
    
    [super tearDown];
}

- (void)testThatItDeterminesCorrectCombinationsOfData {
    HKQuantityTypeIdentifier activeEnergy = HKQuantityTypeIdentifierActiveEnergyBurned;
    HKQuantityTypeIdentifier baseEnergy = HKQuantityTypeIdentifierBasalEnergyBurned;
    HKQuantityTypeIdentifier dietaryEnergy = HKQuantityTypeIdentifierDietaryEnergyConsumed;
    
    HKQuantityTypeIdentifier stepCount = HKQuantityTypeIdentifierStepCount;
    HKQuantityTypeIdentifier swimDistance = HKQuantityTypeIdentifierDistanceSwimming;
    
    XCTAssertTrue([MTSHealthDataCoordinator healthType:activeEnergy canBeGroupedWithHealthType:baseEnergy]);
    XCTAssertTrue([MTSHealthDataCoordinator healthType:activeEnergy canBeGroupedWithHealthType:dietaryEnergy]);
    XCTAssertTrue([MTSHealthDataCoordinator healthType:baseEnergy canBeGroupedWithHealthType:dietaryEnergy]);
    
    XCTAssertFalse([MTSHealthDataCoordinator healthType:activeEnergy canBeGroupedWithHealthType:stepCount]);
    XCTAssertFalse([MTSHealthDataCoordinator healthType:activeEnergy canBeGroupedWithHealthType:swimDistance]);
    
    XCTAssertFalse([MTSHealthDataCoordinator healthType:baseEnergy canBeGroupedWithHealthType:stepCount]);
    XCTAssertFalse([MTSHealthDataCoordinator healthType:baseEnergy canBeGroupedWithHealthType:swimDistance]);
    
    XCTAssertFalse([MTSHealthDataCoordinator healthType:dietaryEnergy canBeGroupedWithHealthType:stepCount]);
    XCTAssertFalse([MTSHealthDataCoordinator healthType:dietaryEnergy canBeGroupedWithHealthType:swimDistance]);
    
    XCTAssertFalse([MTSHealthDataCoordinator healthType:stepCount canBeGroupedWithHealthType:swimDistance]);
}

- (void)testThatItRequestsReadAccessToHealthKit {
    XCTestExpectation *accessExpectation = [self expectationWithDescription:@"Test was granted access to HKHealthStore."];
    [MTSHealthDataCoordinator requestReadAccessForHealthStore:[self healthStore]
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

@end
