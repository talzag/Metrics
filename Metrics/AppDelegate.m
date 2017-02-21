//
//  AppDelegate.m
//  Metrics
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "AppDelegate.h"
#import "MTSGraphCollectionViewController.h"

@interface AppDelegate ()

@property (strong) HKHealthStore *healthStore;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.healthStore = [[HKHealthStore alloc] init];
    [self requestHealthSharingAuthorization];
    
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    MTSGraphCollectionViewController *graphsViewController = (MTSGraphCollectionViewController *)navController.viewControllers.firstObject;
    graphsViewController.managedObjectContext = self.persistentContainer.viewContext;
    
    return YES;
}

- (void)requestHealthSharingAuthorization {
    __weak AppDelegate *weakSelf = self;
    [self.healthStore requestAuthorizationToShareTypes:nil
                                             readTypes:[self healthTypesToRead]
                                            completion:^(BOOL success, NSError * _Nullable error) {
                                                if (!success) {
                                                    NSLog(@"ERROR: %@", error.localizedDescription);
                                                    abort();
                                                }
                                                
                                                AppDelegate *delegate = weakSelf;
                                                
                                                UINavigationController *navController = (UINavigationController *)[delegate.window rootViewController];
                                                MTSGraphCollectionViewController *graphViewController = (MTSGraphCollectionViewController *)[[navController viewControllers] firstObject];
                                                graphViewController.healthStore = delegate.healthStore;
                                            }];
}

- (NSArray <HKQuantityTypeIdentifier>*)quantityTypeIdentifiers {
    NSArray *quantityTypes = @[
                               // Body Measurements
                               HKQuantityTypeIdentifierBodyMassIndex,
                               HKQuantityTypeIdentifierBodyFatPercentage,
                               HKQuantityTypeIdentifierHeight,
                               HKQuantityTypeIdentifierBodyMass,
                               HKQuantityTypeIdentifierLeanBodyMass,
                               
                               // Fitness
                               HKQuantityTypeIdentifierStepCount,
                               HKQuantityTypeIdentifierDistanceWalkingRunning,
                               HKQuantityTypeIdentifierDistanceCycling,
                               HKQuantityTypeIdentifierDistanceWheelchair,
                               HKQuantityTypeIdentifierBasalEnergyBurned,
                               HKQuantityTypeIdentifierActiveEnergyBurned,
                               HKQuantityTypeIdentifierFlightsClimbed,
                               HKQuantityTypeIdentifierNikeFuel,
                               HKQuantityTypeIdentifierAppleExerciseTime,
                               HKQuantityTypeIdentifierPushCount,
                               HKQuantityTypeIdentifierDistanceSwimming,
                               HKQuantityTypeIdentifierSwimmingStrokeCount,
                               
                               // Vitals
                               HKQuantityTypeIdentifierHeartRate,
                               HKQuantityTypeIdentifierBodyTemperature,
                               HKQuantityTypeIdentifierBasalBodyTemperature,
                               HKQuantityTypeIdentifierBloodPressureSystolic,
                               HKQuantityTypeIdentifierBloodPressureDiastolic,
                               HKQuantityTypeIdentifierRespiratoryRate,
                               
                               // Results
                               HKQuantityTypeIdentifierOxygenSaturation,
                               HKQuantityTypeIdentifierPeripheralPerfusionIndex,
                               HKQuantityTypeIdentifierBloodGlucose,
                               HKQuantityTypeIdentifierNumberOfTimesFallen,
                               HKQuantityTypeIdentifierElectrodermalActivity,
                               HKQuantityTypeIdentifierInhalerUsage,
                               HKQuantityTypeIdentifierBloodAlcoholContent,
                               HKQuantityTypeIdentifierForcedVitalCapacity,
                               HKQuantityTypeIdentifierForcedExpiratoryVolume1,
                               HKQuantityTypeIdentifierPeakExpiratoryFlowRate,
                               
                               // Nutrition
                               HKQuantityTypeIdentifierDietaryFatTotal,
                               HKQuantityTypeIdentifierDietaryFatPolyunsaturated,
                               HKQuantityTypeIdentifierDietaryFatMonounsaturated,
                               HKQuantityTypeIdentifierDietaryFatSaturated,
                               HKQuantityTypeIdentifierDietaryCholesterol,
                               HKQuantityTypeIdentifierDietarySodium,
                               HKQuantityTypeIdentifierDietaryCarbohydrates,
                               HKQuantityTypeIdentifierDietaryFiber,
                               HKQuantityTypeIdentifierDietarySugar,
                               HKQuantityTypeIdentifierDietaryEnergyConsumed,
                               HKQuantityTypeIdentifierDietaryProtein,
                               HKQuantityTypeIdentifierDietaryVitaminA,
                               HKQuantityTypeIdentifierDietaryVitaminB6,
                               HKQuantityTypeIdentifierDietaryVitaminB12,
                               HKQuantityTypeIdentifierDietaryVitaminC,
                               HKQuantityTypeIdentifierDietaryVitaminD,
                               HKQuantityTypeIdentifierDietaryVitaminE,
                               HKQuantityTypeIdentifierDietaryVitaminK,
                               HKQuantityTypeIdentifierDietaryCalcium,
                               HKQuantityTypeIdentifierDietaryIron,
                               HKQuantityTypeIdentifierDietaryThiamin,
                               HKQuantityTypeIdentifierDietaryRiboflavin,
                               HKQuantityTypeIdentifierDietaryNiacin,
                               HKQuantityTypeIdentifierDietaryFolate,
                               HKQuantityTypeIdentifierDietaryBiotin,
                               HKQuantityTypeIdentifierDietaryPantothenicAcid,
                               HKQuantityTypeIdentifierDietaryPhosphorus,
                               HKQuantityTypeIdentifierDietaryIodine,
                               HKQuantityTypeIdentifierDietaryMagnesium,
                               HKQuantityTypeIdentifierDietaryZinc,
                               HKQuantityTypeIdentifierDietarySelenium,
                               HKQuantityTypeIdentifierDietaryCopper,
                               HKQuantityTypeIdentifierDietaryManganese,
                               HKQuantityTypeIdentifierDietaryChromium,
                               HKQuantityTypeIdentifierDietaryMolybdenum,
                               HKQuantityTypeIdentifierDietaryChloride,
                               HKQuantityTypeIdentifierDietaryPotassium,
                               HKQuantityTypeIdentifierDietaryCaffeine,
                               HKQuantityTypeIdentifierDietaryWater,
                               HKQuantityTypeIdentifierUVExposure,
                               HKQuantityTypeIdentifierDietaryEnergyConsumed,
                               HKQuantityTypeIdentifierBasalEnergyBurned,
                               HKQuantityTypeIdentifierActiveEnergyBurned
                               ];
    return quantityTypes;
}

- (NSArray <HKCategoryTypeIdentifier>*)categoryTypeIdentifiers {
    NSArray *categoryTypes = @[
                               HKCategoryTypeIdentifierSleepAnalysis,
                               HKCategoryTypeIdentifierAppleStandHour,
                               HKCategoryTypeIdentifierCervicalMucusQuality,
                               HKCategoryTypeIdentifierOvulationTestResult,
                               HKCategoryTypeIdentifierMenstrualFlow,
                               HKCategoryTypeIdentifierIntermenstrualBleeding,
                               HKCategoryTypeIdentifierSexualActivity,
                               HKCategoryTypeIdentifierMindfulSession
                               ];
    
    return categoryTypes;
}

- (NSSet *)healthTypesToRead {
    NSMutableSet *readTypes = [NSMutableSet set];
    
    for (HKQuantityTypeIdentifier ident in self.quantityTypeIdentifiers) {
        [readTypes addObject:[HKObjectType quantityTypeForIdentifier:ident]];
    }
    
    for (HKCategoryTypeIdentifier ident in self.categoryTypeIdentifiers) {
        [readTypes addObject:[HKObjectType categoryTypeForIdentifier:ident]];
    }
    
    return [NSSet setWithSet:readTypes];
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Metrics"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
