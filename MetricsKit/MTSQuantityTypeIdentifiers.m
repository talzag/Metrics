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
             @"Swimming Stroke Count": HKQuantityTypeIdentifierSwimmingStrokeCount
             };
}

NSDictionary <HKQuantityTypeIdentifier, NSString *> *MTSQuantityTypeVitalsIdentifiers(void) {
    return @{
             @"Heart Rate": HKQuantityTypeIdentifierHeartRate,
             @"Body Temperature": HKQuantityTypeIdentifierBodyTemperature,
             @"Base Body Temperature": HKQuantityTypeIdentifierBasalBodyTemperature,
             @"Systolic Blood Pressure": HKQuantityTypeIdentifierBloodPressureSystolic,
             @"Diastolic Blood Pressure": HKQuantityTypeIdentifierBloodPressureDiastolic,
             @"Respiratory Rate": HKQuantityTypeIdentifierRespiratoryRate,
             };
}

NSDictionary <HKQuantityTypeIdentifier, NSString *> *MTSQuantityTypeResultsIdentifiers(void) {
    return @{
             @"Oxygen Saturation": HKQuantityTypeIdentifierOxygenSaturation,
             @"Peripheral Perfusion Index": HKQuantityTypeIdentifierPeripheralPerfusionIndex,
             @"Blood Glucose": HKQuantityTypeIdentifierBloodGlucose,
             @"Number of Times Fallen": HKQuantityTypeIdentifierNumberOfTimesFallen,
             @"Electrodermal Activity": HKQuantityTypeIdentifierElectrodermalActivity,
             @"Inhaler Usage": HKQuantityTypeIdentifierInhalerUsage,
             @"Blood Alcohol Content": HKQuantityTypeIdentifierBloodAlcoholContent,
             @"Forced Vital Capacity": HKQuantityTypeIdentifierForcedVitalCapacity,
             @"Forced Expiratory Volume": HKQuantityTypeIdentifierForcedExpiratoryVolume1,
             @"Peak Expiratory Flow Rate": HKQuantityTypeIdentifierPeakExpiratoryFlowRate
             };
}

NSDictionary <HKQuantityTypeIdentifier, NSString *> *MTSQuantityTypeNutritionIdentifiers(void) {
    return @{
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
