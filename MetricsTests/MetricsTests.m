//
//  MetricsTests.m
//  MetricsTests
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <XCTest/XCTest.h>
@import CoreData;
@import HealthKit;

#import "MTSGraph+CoreDataClass.h"
#import "MTSGraphView.h"

@interface MetricsTests : XCTestCase

@property (nonatomic) NSManagedObjectModel *model;
@property (nonatomic) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation MetricsTests

- (NSManagedObjectModel *)model {
    if (!_model) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Metrics" withExtension:@"momd"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        _model = model;
    }
    
    return _model;
}

- (NSPersistentStoreCoordinator *)coordinator {
    if (!_coordinator) {
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];
        [coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
        
        _coordinator = coordinator;
    }
    
    return _coordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [context setPersistentStoreCoordinator:[self coordinator]];
        
        _managedObjectContext = context;
    }
    
    return _managedObjectContext;
}

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [self setManagedObjectContext:nil];
    [super tearDown];
}

- (void)testThatGraphDataIsSaved {
    NSDictionary *data = @{
                           MTSGraphLineColorKey: [UIColor blueColor],
                           MTSGraphDataPointsKey: @[@25, @50, @75, @100, @50, @75, @25]
                           };
    NSSet *dataPoints = [NSSet setWithObject:data];
    
    MTSGraph *graph = [[MTSGraph alloc] initWithContext:[self managedObjectContext]];
    graph.dataPoints = dataPoints;
    
    [[self managedObjectContext] save:nil];
    
    NSManagedObjectID *graphID = [graph objectID];
    MTSGraph *copy = [[self managedObjectContext] objectWithID:graphID];
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
    
    MTSGraph *graph = [[MTSGraph alloc] initWithContext:[self managedObjectContext]];
    [graph setQuantityHealthTypeIdentifiers:quantityIdents];
    [graph setCategoryHealthTypeIdentifiers: categoryIdents];
    
    [[self managedObjectContext] save:nil];
    
    NSManagedObjectID *graphID = [graph objectID];
    MTSGraph *copy = [[self managedObjectContext] objectWithID:graphID];
    
    NSSet* copyQuantityIdents = [copy quantityHealthTypeIdentifiers];
    XCTAssertEqualObjects(quantityIdents, copyQuantityIdents);
    
    NSSet* copyCategoryIdents = [graph categoryHealthTypeIdentifiers];
    XCTAssertEqualObjects(categoryIdents, copyCategoryIdents);
}

@end
