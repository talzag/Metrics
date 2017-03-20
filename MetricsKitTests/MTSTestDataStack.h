//
//  MTSTestDataStack.h
//  Metrics
//
//  Created by Daniel Strokis on 3/18/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import Foundation;
@import CoreData;
@import HealthKit;

@interface MTSTestDataStack : NSObject

@property (nonatomic, nullable) NSManagedObjectModel *model;
@property (nonatomic, nullable) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, nullable) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, nonnull) NSSet *healthDataTypes;

- (void)insertMockHealthDataIntoHealthStore:(nonnull HKHealthStore *)healthStore
                          completionHandler:(void (^ _Nullable)(BOOL success, NSError * _Nullable error))completionHandler;

- (void)deleteMockDataFromHealthStore:(HKHealthStore * _Nonnull)healthStore
                withCompletionHandler:(void (^ _Nullable)(void))completionHandler;
@end
