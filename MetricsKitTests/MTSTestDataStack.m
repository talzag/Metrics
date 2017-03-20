//
//  MTSTestDataStack.m
//  Metrics
//
//  Created by Daniel Strokis on 3/18/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSTestDataStack.h"

@implementation MTSTestDataStack

- (NSManagedObjectModel *)model {
    if (!_model) {
        NSBundle *metricsKit = [NSBundle bundleWithIdentifier:@"com.dstrokis.MetricsKit"];
        NSURL *modelURL = [metricsKit URLForResource:@"Metrics" withExtension:@"momd"];
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

- (NSSet *)healthDataTypes {
    HKQuantityType *activeEnergy = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *dietaryEnery = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    HKQuantityType *baseEnergy = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned];
    
    return [NSSet setWithObjects:activeEnergy, dietaryEnery, baseEnergy, nil];
}

- (void)insertMockHealthDataIntoHealthStore:(HKHealthStore *)healthStore completionHandler:(void (^ _Nullable)(BOOL success, NSError * _Nullable error))completionHandler {
    NSDate *now = [NSDate date];
    HKQuantity *calories = [HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit]
                                            doubleValue:100];
    
    HKQuantityType *activeEnergy = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantitySample *activeEnergySample = [HKQuantitySample quantitySampleWithType:activeEnergy
                                                                           quantity:calories
                                                                          startDate:now
                                                                            endDate:now];
    
    HKQuantityType *dietaryEnery = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    HKQuantitySample *dietaryEnergySample = [HKQuantitySample quantitySampleWithType:dietaryEnery
                                                                            quantity:calories
                                                                           startDate:now
                                                                             endDate:now];
    
    HKQuantityType *baseEnergy = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned];
    HKQuantitySample *baseEnergySample = [HKQuantitySample quantitySampleWithType:baseEnergy
                                                                         quantity:calories
                                                                        startDate:now
                                                                          endDate:now];
    
    [healthStore saveObjects:@[activeEnergySample, dietaryEnergySample, baseEnergySample] withCompletion:^(BOOL success, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(success, error);
        }
    }];
}

- (void)deleteMockDataFromHealthStore:(HKHealthStore *)healthStore
                withCompletionHandler:(void (^ _Nullable)(void))completionHandler {
    
    long value = [[self healthDataTypes] count];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(value);
    
    NSPredicate *predicate = [HKQuery predicateForObjectsFromSource:[HKSource defaultSource]];
    for (HKQuantityType *type in [self healthDataTypes]) {
        [healthStore deleteObjectsOfType:type
                               predicate:predicate
                          withCompletion:^(BOOL success, NSUInteger deletedObjectCount, NSError * _Nullable error) {
                              if (success) {
                                  dispatch_semaphore_signal(semaphore);
                              }
                          }];
    }
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    if (completionHandler) {
        completionHandler();
    }
}

@end
