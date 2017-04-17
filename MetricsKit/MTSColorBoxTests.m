//
//  MTSColorBoxTests.m
//  Metrics
//
//  Created by Daniel Strokis on 4/15/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import XCTest;
@import CoreData;
@import HealthKit;
@import UIKit;

#import "MTSColorBox.h"

@interface MTSColorBoxTests : XCTestCase

@property MTSColorBox *colorBox;

@end

@implementation MTSColorBoxTests

- (void)setUp {
    [super setUp];
    
    UIColor *blue = [UIColor blueColor];
    MTSColorBox *blueBox = [[MTSColorBox alloc] initWithCGColorRef:[blue CGColor]];
    [self setColorBox:blueBox];
}

- (void)tearDown {
    [self setColorBox:nil];
    
    [super tearDown];
}

- (void)testThatItArchivesCorrectly {
    NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:[self colorBox]];
    XCTAssertNotNil(archive);
    
    id unarchive = [NSKeyedUnarchiver unarchiveObjectWithData:archive];
    XCTAssert([unarchive isKindOfClass:[MTSColorBox class]]);
    XCTAssert([[self colorBox] color] != NULL);
}

- (void)testThatItConformsToNSCoding {
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [[self colorBox] encodeWithCoder:archiver];
    [archiver finishEncoding];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    MTSColorBox *box = [[MTSColorBox alloc] initWithCoder:unarchiver];
    XCTAssertNotNil(box);
    XCTAssertEqual([[self colorBox] color], [[UIColor blueColor] CGColor]);
}

@end
