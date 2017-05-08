//
//  MTSGraphsTableViewControllerTests.m
//  Metrics
//
//  Created by Daniel Strokis on 5/8/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import XCTest;
@import HealthKit;
@import CoreData;

#import "AppDelegate.h"
#import "MTSGraphsTableViewController.h"

@interface MTSGraphsTableViewControllerTests : XCTestCase

@property MTSGraphsTableViewController *testController;

@end

@implementation MTSGraphsTableViewControllerTests

- (void)setUp {
    [super setUp];
    
    UIApplication *app =  [UIApplication sharedApplication];
    AppDelegate *delegate = (AppDelegate *)[app delegate];
    NSManagedObjectContext *context = [[delegate persistentContainer] viewContext];
    
    MTSGraphsTableViewController *controller = [MTSGraphsTableViewController new];
    [controller setManagedObjectContext:context];
    [controller setHealthStore:[delegate healthStore]];
    
    [self setTestController:controller];
}

- (void)tearDown {
    [self setTestController:nil];
    [super tearDown];
}



@end
