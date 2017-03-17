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
    graphsViewController.quantityTypeIdentifiers = self.quantityTypeIdentifiers;
    
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

// TODO: Move these to MetricsKit

- (NSDictionary <NSString *, HKQuantityTypeIdentifier>*)quantityTypeIdentifiers {
    NSDictionary *quantityTypes = @{
                                   // Body Measurements
                                   @"Body Mass Index": HKQuantityTypeIdentifierBodyMassIndex,
                                   @"Body Fat Percentage": HKQuantityTypeIdentifierBodyFatPercentage,
                                   @"Height": HKQuantityTypeIdentifierHeight,
                                   @"Body Mass": HKQuantityTypeIdentifierBodyMass,
                                   @"Lean Body Mass": HKQuantityTypeIdentifierLeanBodyMass,
                                   
                                   // Fitness
                                   @"Step Count": HKQuantityTypeIdentifierStepCount,
                                   @"Walking/Running Distance": HKQuantityTypeIdentifierDistanceWalkingRunning,
                                   @"Cycling Distance": HKQuantityTypeIdentifierDistanceCycling,
                                   @"Wheelchair Distance": HKQuantityTypeIdentifierDistanceWheelchair,
                                   @"Base Energy Burned": HKQuantityTypeIdentifierBasalEnergyBurned,
                                   @"Active Energy Burned": HKQuantityTypeIdentifierActiveEnergyBurned,
                                   @"Flights Climbed": HKQuantityTypeIdentifierFlightsClimbed,
                                   @"Nike Fuel": HKQuantityTypeIdentifierNikeFuel,
                                   @"Exercise Time": HKQuantityTypeIdentifierAppleExerciseTime,
                                   @"Wheelchair Pushes": HKQuantityTypeIdentifierPushCount,
                                   @"Swimming Distance": HKQuantityTypeIdentifierDistanceSwimming,
                                   @"Swimming Stroke Count": HKQuantityTypeIdentifierSwimmingStrokeCount,
                                   
                                   // Vitals
                                   @"Heart Rate": HKQuantityTypeIdentifierHeartRate,
                                   @"Body Temperature": HKQuantityTypeIdentifierBodyTemperature,
                                   @"Base Body Temperature": HKQuantityTypeIdentifierBasalBodyTemperature,
                                   @"Systolic Blood Pressure": HKQuantityTypeIdentifierBloodPressureSystolic,
                                   @"Diastolic Blood Pressure": HKQuantityTypeIdentifierBloodPressureDiastolic,
                                   @"Respiratory Rate": HKQuantityTypeIdentifierRespiratoryRate,
                                   
                                   // Results
                                   @"Oxygen Saturation": HKQuantityTypeIdentifierOxygenSaturation,
                                   @"Peripheral Perfusion Index": HKQuantityTypeIdentifierPeripheralPerfusionIndex,
                                   @"Blood Glucose": HKQuantityTypeIdentifierBloodGlucose,
                                   @"Number of Times Fallen": HKQuantityTypeIdentifierNumberOfTimesFallen,
                                   @"Electrodermal Activity": HKQuantityTypeIdentifierElectrodermalActivity,
                                   @"Inhaler Usage": HKQuantityTypeIdentifierInhalerUsage,
                                   @"Blood Alcohol Content": HKQuantityTypeIdentifierBloodAlcoholContent,
                                   @"Forced Vital Capacity": HKQuantityTypeIdentifierForcedVitalCapacity,
                                   @"Forced Expiratory Volume": HKQuantityTypeIdentifierForcedExpiratoryVolume1,
                                   @"Peak Expiratory Flow Rate": HKQuantityTypeIdentifierPeakExpiratoryFlowRate,
                                   
                                   // Nutrition
                                   @"Total Fat": HKQuantityTypeIdentifierDietaryFatTotal,
                                   @"Polyunsaturated Fat": HKQuantityTypeIdentifierDietaryFatPolyunsaturated,
                                   @"Monounstaurated Fat": HKQuantityTypeIdentifierDietaryFatMonounsaturated,
                                   @"Saturated Fat": HKQuantityTypeIdentifierDietaryFatSaturated,
                                   @"Cholesterol": HKQuantityTypeIdentifierDietaryCholesterol,
                                   @"Sodium": HKQuantityTypeIdentifierDietarySodium,
                                   @"Carbohydrates": HKQuantityTypeIdentifierDietaryCarbohydrates,
                                   @"Fiber": HKQuantityTypeIdentifierDietaryFiber,
                                   @"Sugar": HKQuantityTypeIdentifierDietarySugar,
                                   @"Calories Eaten": HKQuantityTypeIdentifierDietaryEnergyConsumed,
                                   @"Protein": HKQuantityTypeIdentifierDietaryProtein,
                                   @"Vitamin A": HKQuantityTypeIdentifierDietaryVitaminA,
                                   @"Vitamin B6": HKQuantityTypeIdentifierDietaryVitaminB6,
                                   @"Vitamin B12": HKQuantityTypeIdentifierDietaryVitaminB12,
                                   @"Vitamin C": HKQuantityTypeIdentifierDietaryVitaminC,
                                   @"Vitamin D": HKQuantityTypeIdentifierDietaryVitaminD,
                                   @"Vitamin E": HKQuantityTypeIdentifierDietaryVitaminE,
                                   @"Vitamin K": HKQuantityTypeIdentifierDietaryVitaminK,
                                   @"Calcium": HKQuantityTypeIdentifierDietaryCalcium,
                                   @"Iron": HKQuantityTypeIdentifierDietaryIron,
                                   @"Thiamin": HKQuantityTypeIdentifierDietaryThiamin,
                                   @"Riboflavin": HKQuantityTypeIdentifierDietaryRiboflavin,
                                   @"Niacin": HKQuantityTypeIdentifierDietaryNiacin,
                                   @"Folate": HKQuantityTypeIdentifierDietaryFolate,
                                   @"Biotin": HKQuantityTypeIdentifierDietaryBiotin,
                                   @"Pantothenic Acid": HKQuantityTypeIdentifierDietaryPantothenicAcid,
                                   @"Phosphorus": HKQuantityTypeIdentifierDietaryPhosphorus,
                                   @"Iodine": HKQuantityTypeIdentifierDietaryIodine,
                                   @"Magnesium": HKQuantityTypeIdentifierDietaryMagnesium,
                                   @"Zinc": HKQuantityTypeIdentifierDietaryZinc,
                                   @"Selenium": HKQuantityTypeIdentifierDietarySelenium,
                                   @"Copper": HKQuantityTypeIdentifierDietaryCopper,
                                   @"Manganese": HKQuantityTypeIdentifierDietaryManganese,
                                   @"Chromium": HKQuantityTypeIdentifierDietaryChromium,
                                   @"Molybdenum": HKQuantityTypeIdentifierDietaryMolybdenum,
                                   @"Chloride": HKQuantityTypeIdentifierDietaryChloride,
                                   @"Potassium": HKQuantityTypeIdentifierDietaryPotassium,
                                   @"Caffeine": HKQuantityTypeIdentifierDietaryCaffeine,
                                   @"Water": HKQuantityTypeIdentifierDietaryWater,
                                   @"UV Exposure": HKQuantityTypeIdentifierUVExposure
                                   };
    return quantityTypes;
}

//- (NSArray <HKCategoryTypeIdentifier>*)categoryTypeIdentifiers {
//    NSArray *categoryTypes = @[
//                               HKCategoryTypeIdentifierSleepAnalysis,
//                               HKCategoryTypeIdentifierAppleStandHour,
//                               HKCategoryTypeIdentifierCervicalMucusQuality,
//                               HKCategoryTypeIdentifierOvulationTestResult,
//                               HKCategoryTypeIdentifierMenstrualFlow,
//                               HKCategoryTypeIdentifierIntermenstrualBleeding,
//                               HKCategoryTypeIdentifierSexualActivity,
//                               HKCategoryTypeIdentifierMindfulSession
//                               ];
//    
//    return categoryTypes;
//}

- (NSSet *)healthTypesToRead {
    NSMutableSet *readTypes = [NSMutableSet set];
    
    [self.quantityTypeIdentifiers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, HKQuantityTypeIdentifier  _Nonnull obj, BOOL * _Nonnull stop) {
        [readTypes addObject:[HKObjectType quantityTypeForIdentifier:obj]];
    }];
    
    
//    for (HKCategoryTypeIdentifier ident in self.categoryTypeIdentifiers) {
//        [readTypes addObject:[HKObjectType categoryTypeForIdentifier:ident]];
//    }
    
    return [NSSet setWithSet:readTypes];
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Metrics"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
#if DEBUG
                    abort();
#endif
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
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
#if DEBUG
        abort();
#endif
    }
}

@end
