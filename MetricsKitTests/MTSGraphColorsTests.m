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
@import UIKit;

#import "MetricsKit.h"
#import "MTSTestDataStack.h"
#import "MTSColorBox.h"

@interface MTSGraphColorsTests : XCTestCase

@property MTSTestDataStack *dataStack;

@end

@implementation MTSGraphColorsTests

- (void)setUp {
    [super setUp];
    
    [self setDataStack:[MTSTestDataStack new]];
}

- (void)tearDown {
    [self setDataStack:nil];
    
    [super tearDown];
}

- (void)testThatColorsAreBoxedCorrectly {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat blackComponents[] = { 0.0, 0.0, 0.0, 1.0 };
    CGColorRef black = CGColorCreate(colorSpace, blackComponents);
    MTSColorBox *blackValue = [[MTSColorBox alloc ] initWithCGColorRef:black];
    XCTAssertNotNil(blackValue);
    
    CGColorRef blackValueBuffer = [blackValue color];
    XCTAssertTrue(blackValueBuffer != NULL);
    
    const CGFloat *blackCompCopy = CGColorGetComponents(blackValueBuffer);
    XCTAssertTrue(blackComponents[0] == *blackCompCopy);
    XCTAssertTrue(blackComponents[1] == *(blackCompCopy + 1));
    XCTAssertTrue(blackComponents[2] == *(blackCompCopy + 2));
    XCTAssertTrue(blackComponents[3] == *(blackCompCopy + 3));
    
    CGColorRelease(black);
    CGColorSpaceRelease(colorSpace);
}

- (void)testThatGraphColorsAreSavedCorrectly {
    MTSGraph *graph = [[MTSGraph alloc] initWithContext:[[self dataStack] managedObjectContext]];
    
    MTSColorBox *blueBox = [[MTSColorBox alloc] initWithCGColorRef:[[UIColor blueColor] CGColor]];
    MTSColorBox *cyanBox = [[MTSColorBox alloc] initWithCGColorRef:[[UIColor cyanColor] CGColor]];
    
    [graph setTopColor:cyanBox];
    [graph setBottomColor:blueBox];

    NSManagedObjectID *objectID = [graph objectID];
    [[[self dataStack] managedObjectContext] save:nil];
    graph = nil;
    
    MTSGraph *saved = [[[self dataStack] managedObjectContext] objectWithID:objectID];
    XCTAssertNotNil(saved);
    XCTAssertEqualObjects([saved topColor], cyanBox);
    XCTAssertEqualObjects([saved bottomColor], blueBox);
}

@end
