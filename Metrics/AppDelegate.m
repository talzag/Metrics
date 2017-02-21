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

@end
