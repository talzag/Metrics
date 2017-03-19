//
//  MTSHealthTypeTransformerTests.m
//  Metrics
//
//  Created by Daniel Strokis on 3/15/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import XCTest;
@import HealthKit;

#import "MTSHealthTypeTransformer.h"

@interface MTSHealthTypeTransformerTests : XCTestCase

@property (nonatomic) MTSHealthTypeTransformer *transformer;

@end

@implementation MTSHealthTypeTransformerTests

- (void)setUp {
    [super setUp];
    
    [self setTransformer:[MTSHealthTypeTransformer new]];
}

- (void)tearDown {
    [self setTransformer:nil];
    
    [super tearDown];
}

- (void)testThatItAllowsReverseTransformation {
    XCTAssertTrue([MTSHealthTypeTransformer allowsReverseTransformation]);
}

- (void)testThatItTransformDataToNSSet {
    XCTAssertEqualObjects([NSSet class], [MTSHealthTypeTransformer transformedValueClass]);
}

- (void)testThatItTransformsDataPoints {
    NSSet *dataPoints = [NSSet setWithObjects:
                         HKQuantityTypeIdentifierDietaryEnergyConsumed,
                         HKQuantityTypeIdentifierActiveEnergyBurned,
                         HKQuantityTypeIdentifierBasalEnergyBurned, nil];
    
    id transformed = [[self transformer] transformedValue:dataPoints];
    XCTAssertTrue([transformed isKindOfClass:[NSData class]]);
}

- (void)testThatItWillHandleTransformingDataThatHasBeenTransformed {
    NSData *emptyData = [NSData data];
    id transformed = [[self transformer] transformedValue:emptyData];
    XCTAssertNil(transformed);
}

- (void)testThatItWillNotTransformDataThatIsNotAnNSSet {
    NSString *name = @"Daniel";
    id transformed = [[self transformer] transformedValue:name];
    XCTAssertNil(transformed);
}

- (void)testThatItWillNotReverseTransformDataThatWasNotAnNSSet {
    NSArray *dataPoints = @[
                            HKQuantityTypeIdentifierDietaryEnergyConsumed,
                            HKQuantityTypeIdentifierActiveEnergyBurned,
                            HKQuantityTypeIdentifierBasalEnergyBurned];
    
    NSData *transformed = [NSKeyedArchiver archivedDataWithRootObject:dataPoints];
    
    id reversed = [[self transformer] reverseTransformedValue:transformed];
    XCTAssertNil(reversed);
}

- (void)testThatItReverseTransformsDataPoints {
    NSSet *dataPoints = [NSSet setWithObjects:
                         HKQuantityTypeIdentifierDietaryEnergyConsumed,
                         HKQuantityTypeIdentifierActiveEnergyBurned,
                         HKQuantityTypeIdentifierBasalEnergyBurned, nil];
    NSData *transformed = [NSKeyedArchiver archivedDataWithRootObject:dataPoints];
    
    id reversed = [[self transformer] reverseTransformedValue:transformed];
    XCTAssertTrue([reversed isKindOfClass:[NSSet class]]);
    XCTAssertEqualObjects((NSSet *)reversed, dataPoints);
}

@end
