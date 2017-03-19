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

@property (nonatomic) NSSet <HKQuantityType *>*healthDataTypes;

@end

@implementation MTSGraphHKQueryTests

- (NSSet *)healthDataTypes {
    HKQuantityType *activeEnergy = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *dietaryEnery = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    HKQuantityType *baseEnergy = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned];
    
    return [NSSet setWithObjects:activeEnergy, dietaryEnery, baseEnergy, nil];
}

- (void)insertMockHealthDataIntoHealthStore:(HKHealthStore *)healthStore completionHandler:(void (^ _Nullable)(BOOL success, NSError * _Nullable error))completionHandler {
    NSDate *now = [NSDate date];
    HKQuantity *calories = [HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit]
                                            doubleValue:100];
    
    HKQuantityType *activeEnergy = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantitySample *activeEnergySample = [HKQuantitySample quantitySampleWithType:activeEnergy
                                                                           quantity:calories
                                                                          startDate:now
                                                                            endDate:now];
    
    HKQuantityType *dietaryEnery = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    HKQuantitySample *dietaryEnergySample = [HKQuantitySample quantitySampleWithType:dietaryEnery
                                                                            quantity:calories
                                                                           startDate:now
                                                                             endDate:now];
    
    HKQuantityType *baseEnergy = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned];
    HKQuantitySample *baseEnergySample = [HKQuantitySample quantitySampleWithType:baseEnergy
                                                                         quantity:calories
                                                                        startDate:now
                                                                          endDate:now];
    
    [healthStore saveObjects:@[activeEnergySample, dietaryEnergySample, baseEnergySample] withCompletion:^(BOOL success, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(success, error);
        }
    }];
}

- (void)setUp {
    [super setUp];
    [self setDataStack:[MTSTestDataStack new]];
    [self setGraph:[[MTSGraph alloc] initWithContext:[[self dataStack] managedObjectContext]]];
    
    [self setHealthStore:[HKHealthStore new]];
    
    XCTestExpectation *writeAccessExpectation = [self expectationWithDescription:@"Write access granted"];
    XCTestExpectation *writeDataExpectation = [self expectationWithDescription:@"Mock health data written"];
    __weak MTSGraphHKQueryTests *weakSelf = self;
    [[self healthStore] requestAuthorizationToShareTypes:[self healthDataTypes]
                                               readTypes:nil
                                              completion:^(BOOL success, NSError * _Nullable error) {
                                                  if (success) {
                                                      [writeAccessExpectation fulfill];
                                                      
                                                      MTSGraphHKQueryTests *this = weakSelf;
                                                      [this insertMockHealthDataIntoHealthStore:this.healthStore completionHandler:^(BOOL success, NSError * _Nullable error) {
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
    [self setGraph:nil];
    [self setDataStack:nil];
    
    NSPredicate *predicate = [HKQuery predicateForObjectsFromSource:[HKSource defaultSource]];
    for (HKQuantityType *type in [self healthDataTypes]) {
        XCTestExpectation *cleanUpExpectation = [self expectationWithDescription:[NSString stringWithFormat:@"Removed %@ health data", type]];
        [[self healthStore] deleteObjectsOfType:type predicate:predicate withCompletion:^(BOOL success, NSUInteger deletedObjectCount, NSError * _Nullable error) {
            if (success) {
                [cleanUpExpectation fulfill];
            }
        }];
    }
    
    [self waitForExpectationsWithTimeout:15 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error attempting to delete data from health store.a");
        }
    }];
    
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
