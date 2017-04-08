//
//  MTSHealthStoreManagerTests.m
//  Metrics
//
//  Created by Daniel Strokis on 3/15/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import XCTest;

#import "MTSHealthStoreManager.h"

@interface MTSHealthStoreManagerTests : XCTestCase

@property MTSHealthStoreManager *coordinator;
@property HKHealthStore *healthStore;

@end

@implementation MTSHealthStoreManagerTests

- (void)setUp {
    [super setUp];
    
    [self setCoordinator:[MTSHealthStoreManager new]];
    
    [self setHealthStore:[HKHealthStore new]];
}

- (void)tearDown {
    [self setCoordinator:nil];
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

@end
