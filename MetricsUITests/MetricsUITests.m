//
//  MetricsUITests.m
//  MetricsUITests
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface MetricsUITests : XCTestCase

@end

@implementation MetricsUITests

- (void)setUp {
    [super setUp];
    
    self.continueAfterFailure = NO;
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    
    [super tearDown];
}

@end
