//
//  AppDelegate.m
//  Metrics
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import HealthKit;
#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong) HKHealthStore *healthStore;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.healthStore = [[HKHealthStore alloc] init];
    [self requestHealthSharingAuthorization];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)requestHealthSharingAuthorization {
    [self.healthStore requestAuthorizationToShareTypes:nil
                                             readTypes:[self healthTypesToRead]
                                            completion:^(BOOL success, NSError * _Nullable error) {
                                                if (!success) {
                                                    NSLog(@"ERROR: %@", error.localizedDescription);
                                                    abort();
                                                }
                                            }];
}

- (NSSet *)healthTypesToRead {
    NSArray *types = @[
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
                       
//                       HKCategoryTypeIdentifierSleepAnalysis,
//                       HKCategoryTypeIdentifierAppleStandHour,
//                       HKCategoryTypeIdentifierCervicalMucusQuality,
//                       HKCategoryTypeIdentifierOvulationTestResult,
//                       HKCategoryTypeIdentifierMenstrualFlow,
//                       HKCategoryTypeIdentifierIntermenstrualBleeding,
//                       HKCategoryTypeIdentifierSexualActivity,
//                       HKCategoryTypeIdentifierMindfulSession
                       ];
    
    NSMutableSet *readTypes = [NSMutableSet set];
    for (HKQuantityTypeIdentifier ident in types) {
        [readTypes addObject:[HKObjectType quantityTypeForIdentifier:ident]];
    }
    
    return [NSSet setWithSet:readTypes];
}

@end
