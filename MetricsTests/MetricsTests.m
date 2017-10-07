//
//  MetricsTests.m
//  MetricsTests
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import XCTest;
@import CoreData;

#import "AppDelegate.h"

@interface MetricsTests : XCTestCase

@end

@implementation MetricsTests

- (void)testThatItCanLoadTheMOM {
    UIApplication *app =  [UIApplication sharedApplication];
    AppDelegate *delegate = (AppDelegate *)[app delegate];
    
    XCTAssertNotNil([[delegate persistentContainer] viewContext]);
}

- (void)testInitialViewControllerHierarcy {
    UIViewController *navViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    XCTAssertTrue([navViewController isKindOfClass:[UINavigationController class]]);
    
    UIViewController *graphsViewController = [[(UINavigationController *)navViewController viewControllers] firstObject];
    XCTAssertTrue([graphsViewController isKindOfClass:[MTSGraphsTableViewController class]]);
}

- (void)testThatItSetsUpViewControllerDependencies {
    UIApplication *app =  [UIApplication sharedApplication];
    AppDelegate *delegate = (AppDelegate *)[app delegate];
    
    UINavigationController *navViewController = (UINavigationController *)[[app keyWindow] rootViewController];
    MTSGraphsTableViewController *graphsViewController = [[navViewController viewControllers] firstObject];
    
    XCTAssertNotNil([graphsViewController managedObjectContext]);
    XCTAssertEqualObjects([[delegate persistentContainer] viewContext], [graphsViewController managedObjectContext]);
}

- (void)testThatItSavesContextOnResignActiveNotification {
    UIApplication *app =  [UIApplication sharedApplication];
    AppDelegate *delegate = (AppDelegate *)[app delegate];
    NSManagedObjectContext *context = [[delegate persistentContainer] viewContext];
    
    // Insert object into managed object context so that save: will be called
    MTSGraph *graph  = [[MTSGraph alloc] initWithContext:context];
    [graph setStartDate:[NSDate date]];
    [graph setEndDate:[NSDate date]];
    
    XCTestExpectation *didSaveExpectation = [self expectationForNotification:NSManagedObjectContextDidSaveNotification
                                                                      object:[[delegate persistentContainer] viewContext]
                                                                     handler:nil];
    [[XCUIDevice sharedDevice] pressButton:XCUIDeviceButtonHome];
    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[didSaveExpectation] timeout:2];
    
    XCTAssertTrue(result == XCTWaiterResultCompleted);
    
    // Clean up CoreData store
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MTSGraph"];
    NSArray *results = [context executeFetchRequest:request error:nil];
    [context deleteObject:[results firstObject]];
    [delegate saveContext];
}

@end
