//
//  ValueTransformerTests.m
//  Metrics
//
//  Created by Daniel Strokis on 3/15/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MTSDataPointsTransformer.h"

@interface MTSDataPointsTransformerTests : XCTestCase

@property (nonatomic) MTSDataPointsTransformer *transformer;

@end

@implementation MTSDataPointsTransformerTests

- (void)setUp {
    [super setUp];
    
    MTSDataPointsTransformer *t = [[MTSDataPointsTransformer alloc] init];
    [self setTransformer:t];
}

- (void)tearDown {
    [self setTransformer:nil];
    
    [super tearDown];
}

- (void)testThatItAllowsReverseTransformation {
    XCTAssertTrue([MTSDataPointsTransformer allowsReverseTransformation]);
}

- (void)testThatItTransformDataToNSSet {
    XCTAssertEqualObjects([NSSet class], [MTSDataPointsTransformer transformedValueClass]);
}

- (void)testThatItTransformsDataPoints {
    NSSet *dataPoints = [NSSet setWithObjects:@25, @50, @47, @123, nil];
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
    NSArray *dataPoints = @[@25, @50, @47, @123];
    NSData *transformed = [NSKeyedArchiver archivedDataWithRootObject:dataPoints];
    
    id reversed = [[self transformer] reverseTransformedValue:transformed];
    XCTAssertNil(reversed);
}

- (void)testThatItReverseTransformsDataPoints {
    NSSet *dataPoints = [NSSet setWithObjects:@25, @50, @47, @123, nil];
    NSData *transformed = [NSKeyedArchiver archivedDataWithRootObject:dataPoints];
    
    id reversed = [[self transformer] reverseTransformedValue:transformed];
    XCTAssertTrue([reversed isKindOfClass:[NSSet class]]);
    XCTAssertEqualObjects((NSSet *)reversed, dataPoints);
}

- (void)testDataTransformingPerformance {
    MTSDataPointsTransformer *transformer = [MTSDataPointsTransformer new];
    
    [self measureBlock:^{
        id transformed = [transformer transformedValue:[NSSet setWithObjects:@25, @50, @47, @123, nil]];
        [transformer reverseTransformedValue:transformed];
    }];
}

@end
