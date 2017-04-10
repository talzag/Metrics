//
//  MTSGraphColorsTests.m
//  Metrics
//
//  Created by Daniel Strokis on 4/9/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import XCTest;
@import CoreData;
@import HealthKit;

#import "MetricsKit.h"
#import "MTSTestDataStack.h"

@interface MTSGraphColorsTests : XCTestCase

@property MTSTestDataStack *dataStack;
@property HKHealthStore *healthStore;

@end

@implementation MTSGraphColorsTests

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

- (void)testThatColorsAreBoxedCorrectly {
    // Create NSValue with CGColorRef
}

- (void)testTransformedColors {
    //
}

@end
