//
//  MTSReadableHealthLabels.m
//  Metrics
//
//  Created by Daniel Strokis on 3/15/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>
#import "MTSQuantityTypeIdentifiers.h"

NSArray <NSDictionary *>*MTSQuantityTypeHealthCategories(void) {
    return @[
             MTSQuantityTypeBodyMeasurementIdentifiers(),
             MTSQuantityTypeFitnessIdentifiers(),
             MTSQuantityTypeVitalsIdentifiers(),
             MTSQuantityTypeResultsIdentifiers(),
             MTSQuantityTypeNutritionIdentifiers()
             ];
}

NSDictionary <HKQuantityTypeIdentifier, NSString *> *MTSQuantityTypeIdentifiers(void) {
    NSMutableDictionary *identifiers = [NSMutableDictionary dictionary];
    
    for (NSDictionary *dict in MTSQuantityTypeHealthCategories()) {
        [identifiers addEntriesFromDictionary:dict];
    }
    
    return [NSDictionary dictionaryWithDictionary:identifiers];
}

NSDictionary <HKQuantityTypeIdentifier, NSString *> *MTSQuantityTypeBodyMeasurementIdentifiers(void) {
     return @{
              HKQuantityTypeIdentifierBodyMassIndex: @"Body Mass Index",
              HKQuantityTypeIdentifierBodyFatPercentage: @"Body Fat Percentage",
              HKQuantityTypeIdentifierHeight: @"Height",
              HKQuantityTypeIdentifierBodyMass: @"Body Mass",
              HKQuantityTypeIdentifierLeanBodyMass: @"Lean Body Mass"
              };
}

NSDictionary <HKQuantityTypeIdentifier, NSString *> *MTSQuantityTypeFitnessIdentifiers(void) {
    return @{
             HKQuantityTypeIdentifierStepCount: @"Step Count",
             HKQuantityTypeIdentifierDistanceWalkingRunning: @"Walking/Running Distance",
             HKQuantityTypeIdentifierDistanceCycling: @"Cycling Distance",
             HKQuantityTypeIdentifierDistanceWheelchair: @"Wheelchair Distance",
             HKQuantityTypeIdentifierBasalEnergyBurned: @"Base Energy Burned",
             HKQuantityTypeIdentifierActiveEnergyBurned: @"Active Energy Burned",
             HKQuantityTypeIdentifierFlightsClimbed: @"Flights Climbed",
             HKQuantityTypeIdentifierNikeFuel: @"Nike Fuel",
             HKQuantityTypeIdentifierAppleExerciseTime: @"Exercise Time",
             HKQuantityTypeIdentifierPushCount: @"Wheelchair Pushes",
             HKQuantityTypeIdentifierDistanceSwimming: @"Swimming Distance",
             HKQuantityTypeIdentifierSwimmingStrokeCount: @"Swimming Stroke Count"
             };
}

NSDictionary <HKQuantityTypeIdentifier, NSString *> *MTSQuantityTypeVitalsIdentifiers(void) {
    return @{
             HKQuantityTypeIdentifierHeartRate: @"Heart Rate",
             HKQuantityTypeIdentifierBodyTemperature: @"Body Temperature",
             HKQuantityTypeIdentifierBasalBodyTemperature: @"Base Body Temperature",
             HKQuantityTypeIdentifierBloodPressureSystolic: @"Systolic Blood Pressure",
             HKQuantityTypeIdentifierBloodPressureDiastolic: @"Diastolic Blood Pressure",
             HKQuantityTypeIdentifierRespiratoryRate: @"Respiratory Rate"
             };
}

NSDictionary <HKQuantityTypeIdentifier, NSString *> *MTSQuantityTypeResultsIdentifiers(void) {
    return @{
             HKQuantityTypeIdentifierOxygenSaturation: @"Oxygen Saturation",
             HKQuantityTypeIdentifierPeripheralPerfusionIndex: @"Peripheral Perfusion Index",
             HKQuantityTypeIdentifierBloodGlucose: @"Blood Glucose",
             HKQuantityTypeIdentifierNumberOfTimesFallen: @"Number of Times Fallen",
             HKQuantityTypeIdentifierElectrodermalActivity: @"Electrodermal Activity",
             HKQuantityTypeIdentifierInhalerUsage: @"Inhaler Usage",
             HKQuantityTypeIdentifierBloodAlcoholContent: @"Blood Alcohol Content",
             HKQuantityTypeIdentifierForcedVitalCapacity: @"Forced Vital Capacity",
             HKQuantityTypeIdentifierForcedExpiratoryVolume1: @"Forced Expiratory Volume",
             HKQuantityTypeIdentifierPeakExpiratoryFlowRate: @"Peak Expiratory Flow Rate"
             };
}

NSDictionary <HKQuantityTypeIdentifier, NSString *> *MTSQuantityTypeNutritionIdentifiers(void) {
    return @{
             HKQuantityTypeIdentifierDietaryFatTotal: @"Total Fat",
             HKQuantityTypeIdentifierDietaryFatPolyunsaturated: @"Polyunsaturated Fat",
             HKQuantityTypeIdentifierDietaryFatMonounsaturated: @"Monounstaurated Fat",
             HKQuantityTypeIdentifierDietaryFatSaturated: @"Saturated Fat",
             HKQuantityTypeIdentifierDietaryCholesterol: @"Cholesterol",
             HKQuantityTypeIdentifierDietarySodium: @"Sodium",
             HKQuantityTypeIdentifierDietaryCarbohydrates: @"Carbohydrates",
             HKQuantityTypeIdentifierDietaryFiber: @"Fiber",
             HKQuantityTypeIdentifierDietarySugar: @"Sugar",
             HKQuantityTypeIdentifierDietaryEnergyConsumed: @"Calories Eaten",
             HKQuantityTypeIdentifierDietaryProtein: @"Protein",
             HKQuantityTypeIdentifierDietaryVitaminA: @"Vitamin A",
             HKQuantityTypeIdentifierDietaryVitaminB6: @"Vitamin B6",
             HKQuantityTypeIdentifierDietaryVitaminB12: @"Vitamin B12",
             HKQuantityTypeIdentifierDietaryVitaminC: @"Vitamin C",
             HKQuantityTypeIdentifierDietaryVitaminD: @"Vitamin D",
             HKQuantityTypeIdentifierDietaryVitaminE: @"Vitamin E",
             HKQuantityTypeIdentifierDietaryVitaminK: @"Vitamin K",
             HKQuantityTypeIdentifierDietaryCalcium: @"Calcium",
             HKQuantityTypeIdentifierDietaryIron: @"Iron",
             HKQuantityTypeIdentifierDietaryThiamin: @"Thiamin",
             HKQuantityTypeIdentifierDietaryRiboflavin: @"Riboflavin",
             HKQuantityTypeIdentifierDietaryNiacin: @"Niacin",
             HKQuantityTypeIdentifierDietaryFolate: @"Folate",
             HKQuantityTypeIdentifierDietaryBiotin: @"Biotin",
             HKQuantityTypeIdentifierDietaryPantothenicAcid: @"Pantothenic Acid",
             HKQuantityTypeIdentifierDietaryPhosphorus: @"Phosphorus",
             HKQuantityTypeIdentifierDietaryIodine: @"Iodine",
             HKQuantityTypeIdentifierDietaryMagnesium: @"Magnesium",
             HKQuantityTypeIdentifierDietaryZinc: @"Zinc",
             HKQuantityTypeIdentifierDietarySelenium: @"Selenium",
             HKQuantityTypeIdentifierDietaryCopper: @"Copper",
             HKQuantityTypeIdentifierDietaryManganese: @"Manganese",
             HKQuantityTypeIdentifierDietaryChromium: @"Chromium",
             HKQuantityTypeIdentifierDietaryMolybdenum: @"Molybdenum",
             HKQuantityTypeIdentifierDietaryChloride: @"Chloride",
             HKQuantityTypeIdentifierDietaryPotassium: @"Potassium",
             HKQuantityTypeIdentifierDietaryCaffeine: @"Caffeine",
             HKQuantityTypeIdentifierDietaryWater: @"Water",
             HKQuantityTypeIdentifierUVExposure: @"UV Exposure"
             };
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
