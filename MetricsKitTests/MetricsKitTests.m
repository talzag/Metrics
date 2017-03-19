//
//  MetricsKitTests.m
//  MetricsKitTests
//
//  Created by Daniel Strokis on 3/14/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import XCTest;
@import CoreData;

#import "MetricsKit.h"
#import "MTSTestDataStack.h"

@interface MetricsKitTests : XCTestCase

@property MTSTestDataStack *dataStack;

@end

@implementation MetricsKitTests

- (void)setUp {
    [super setUp];
    [self setDataStack:[MTSTestDataStack new]];
}

- (void)tearDown {
    [self setDataStack:nil];
    [super tearDown];
}

- (void)testThatGraphDataIsSaved {
    NSDictionary *data = @{
                           MTSGraphLineColorKey: [UIColor blueColor],
                           MTSGraphDataPointsKey: @[@25, @50, @75, @100, @50, @75, @25]
                           };
    NSSet *dataPoints = [NSSet setWithObject:data];
    
    MTSGraph *graph = [[MTSGraph alloc] initWithContext:[[self dataStack] managedObjectContext]];
    graph.dataPoints = dataPoints;
    
    [[[self dataStack] managedObjectContext] save:nil];
    
    NSManagedObjectID *graphID = [graph objectID];
    MTSGraph *copy = [[[self dataStack] managedObjectContext] objectWithID:graphID];
    NSSet *savedDataPoints = [copy dataPoints];
    NSDictionary *savedData = [savedDataPoints anyObject];
    
    UIColor *originalColor = [data objectForKey:MTSGraphLineColorKey];
    UIColor *color = [savedData objectForKey:MTSGraphLineColorKey];
    XCTAssertEqualObjects(color, originalColor);
    
    NSArray *original = [data objectForKey:MTSGraphDataPointsKey];
    NSArray *points = [savedData objectForKey:MTSGraphDataPointsKey];
    XCTAssertEqualObjects(points, original);
}

- (void)testThatGraphHealthIdentifiersAreSaved {
    NSSet *quantityIdents = [NSSet setWithObjects:HKQuantityTypeIdentifierDietaryWater, HKQuantityTypeIdentifierActiveEnergyBurned, nil];
    NSSet *categoryIdents = [NSSet setWithObjects:HKCategoryTypeIdentifierSleepAnalysis, nil];
    
    MTSGraph *graph = [[MTSGraph alloc] initWithContext:[[self dataStack] managedObjectContext]];
    [graph setQuantityHealthTypeIdentifiers:quantityIdents];
    [graph setCategoryHealthTypeIdentifiers: categoryIdents];
    
    [[[self dataStack] managedObjectContext] save:nil];
    
    NSManagedObjectID *graphID = [graph objectID];
    MTSGraph *copy = [[[self dataStack] managedObjectContext] objectWithID:graphID];
    
    NSSet* copyQuantityIdents = [copy quantityHealthTypeIdentifiers];
    XCTAssertEqualObjects(quantityIdents, copyQuantityIdents);
    
    NSSet* copyCategoryIdents = [graph categoryHealthTypeIdentifiers];
    XCTAssertEqualObjects(categoryIdents, copyCategoryIdents);
}

@end
