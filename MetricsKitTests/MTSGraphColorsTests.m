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
#import "NSValue+Color.h"

@interface MTSGraphColorsTests : XCTestCase

@end

@implementation MTSGraphColorsTests

- (void)testThatColorsAreBoxedCorrectly {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat blackComponents[] = { 0.0, 0.0, 0.0, 1.0 };
    CGColorRef black = CGColorCreate(colorSpace, blackComponents);
    NSValue *blackValue = [NSValue valueWithCGColorRef:black];
    XCTAssertNotNil(blackValue);
    
    CGColorRef blackValueBuffer = [blackValue colorValue];
    XCTAssertTrue(blackValueBuffer != NULL);
    
    const CGFloat *blackCompCopy = CGColorGetComponents(blackValueBuffer);
    XCTAssertTrue(blackComponents[0] == *blackCompCopy);
    XCTAssertTrue(blackComponents[1] == *(blackCompCopy + 1));
    XCTAssertTrue(blackComponents[2] == *(blackCompCopy + 2));
    XCTAssertTrue(blackComponents[3] == *(blackCompCopy + 3));
    
    CGColorRelease(black);
    CGColorSpaceRelease(colorSpace);
}

@end
