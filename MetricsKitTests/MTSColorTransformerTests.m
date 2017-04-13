//
//  MTSColorTransformerTests.m
//  Metrics
//
//  Created by Daniel Strokis on 4/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import XCTest;
@import CoreGraphics;

#import "MTSColorTransformer.h"

@interface MTSColorTransformerTests : XCTestCase

@property MTSColorTransformer *transformer;

@end

@implementation MTSColorTransformerTests

- (void)setUp {
    [super setUp];
    
    [self setTransformer:[MTSColorTransformer new]];
}

- (void)tearDown {
    [self setTransformer:nil];
    
    [super tearDown];
}

- (void)testThatItAllowsReverseTransformation {
    XCTAssertTrue([MTSColorTransformer allowsReverseTransformation]);
}

- (void)testThatItTransformsDataToNSValue {
    XCTAssertEqualObjects([NSValue class], [MTSColorTransformer transformedValueClass]);
}

- (void)testThatItWillTransformAnNSValue {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat comps[] = { 0.0, 0.0, 0.0, 1.0 };
    CGColorRef black = CGColorCreate(colorSpace, comps);
    MTSColorBox *value = [MTSColorBox valueWithCGColorRef:black];
    
    id transformed = [[self transformer] transformedValue:value];
    XCTAssertTrue([transformed isKindOfClass:[NSData class]]);
    
    CGColorRelease(black);
    CGColorSpaceRelease(colorSpace);
}

- (void)testThatItWillHandleTransformingDataThatHasBeenTransformed {
    NSData *emptyData = [NSData data];
    id transformed = [[self transformer] transformedValue:emptyData];
    XCTAssertNil(transformed);
}

- (void)testThatItWillNotTransformDataThatIsNotAnNSValue {
    NSString *name = @"Daniel";
    id transformed = [[self transformer] transformedValue:name];
    XCTAssertNil(transformed);
}

- (void)testThatItWillNotReverseTransformDataThatWasNotAnNSValue {
    NSArray *testData = @[@"Hello", @"World"];
    
    NSData *transformed = [NSKeyedArchiver archivedDataWithRootObject:testData];
    
    id reversed = [[self transformer] reverseTransformedValue:transformed];
    XCTAssertNil(reversed);
}

- (void)testThatItReverseTransformsDataPoints {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat comps[] = { 0.0, 0.0, 0.0, 1.0 };
    CGColorRef black = CGColorCreate(colorSpace, comps);
    MTSColorBox *value = [MTSColorBox valueWithCGColorRef:black];
    NSData *transformed = [NSKeyedArchiver archivedDataWithRootObject:value];
    
    id reversed = [[self transformer] reverseTransformedValue:transformed];
    XCTAssertTrue([reversed isKindOfClass:[NSValue class]]);
    XCTAssertEqualObjects((NSValue *)reversed, value);
    
    CGColorRelease(black);
    CGColorSpaceRelease(colorSpace);
}

- (void)testDataTransformingPerformance {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat comps[] = { 0.0, 0.0, 0.0, 1.0 };
    CGColorRef black = CGColorCreate(colorSpace, comps);
    MTSColorBox *value = [MTSColorBox valueWithCGColorRef:black];
    
    MTSColorTransformer *transformer = [self transformer];
    
    [self measureBlock:^{
        id transformed = [transformer transformedValue:value];
        
        [transformer reverseTransformedValue:transformed];
    }];
    
    CGColorRelease(black);
    CGColorSpaceRelease(colorSpace);
}

@end
