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
@property MTSGraph *testGraph;

@end

@implementation MTSGraphsTableViewControllerTests

- (UIApplication *)app {
    return [UIApplication sharedApplication];
}

- (AppDelegate *)delegate {
    return (AppDelegate *)[[self app] delegate];
}

- (NSManagedObjectContext *)context {
    return [[[self delegate] persistentContainer] viewContext];
}

- (void)setUp {
    [super setUp];
    
    MTSGraph *graph = [[MTSGraph alloc] initWithContext:[self context]];
    [self setTestGraph:graph];
    
    MTSGraphsTableViewController *controller = [MTSGraphsTableViewController new];
    [controller setManagedObjectContext:[self context]];
    [controller setHealthStore:[[self delegate] healthStore]];
    
    [self setTestController:controller];
}

- (void)tearDown {
    [self setTestController:nil];
    [[self context] deleteObject:[self testGraph]];
    
    [super tearDown];
}

- (void)testThatItHandlesContextChanges {
    
}

- (void)testThatDeletingATableViewCellDeletesAnObject {
    
}

- (void)testThatItPreparesSegues {
    
}

@end
