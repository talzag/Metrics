//
//  MTSHealthDataCoordinator.m
//  Metrics
//
//  Created by Daniel Strokis on 3/15/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSHealthDataCoordinator.h"
#import "MTSHealthData.h"
#import "MTSReadableHealthLabels.h"

@implementation MTSHealthDataCoordinator

- (BOOL)healthData:(MTSHealthData *)typeA canBeGroupedWithHealthType:(MTSHealthData *)typeB {
    return (typeA.identifier == HKQuantityTypeIdentifierActiveEnergyBurned ||
            typeA.identifier == HKQuantityTypeIdentifierDietaryEnergyConsumed ||
            typeA.identifier == HKQuantityTypeIdentifierBasalEnergyBurned)
        &&
           (typeB.identifier == HKQuantityTypeIdentifierActiveEnergyBurned ||
            typeB.identifier == HKQuantityTypeIdentifierDietaryEnergyConsumed ||
            typeB.identifier == HKQuantityTypeIdentifierBasalEnergyBurned);
}

- (NSDictionary *)groupableHealthTypesForHealthData:(MTSHealthData *)healthData {
    NSDictionary *types;
    NSUInteger type = [healthData.type unsignedIntegerValue];
    
    switch (type) {
        case MTSDataTypeNutrition:
            types = MTSNutritionIdentifiers();
            break;
        case MTSDataTypeBodyMeasurement:
            types = MTSBodyMeasurementIdentifiers();
            break;
        case MTSDataTypeFitness:
            types = MTSFitnessIdentifiers();
            break;
        case MTSDataTypeVitals:
            types = MTSVitalsIdentifiers();
            break;
        case MTSDataTypeResults:
            types = MTSResultsIdentifiers();
            break;
        default:
            break;
    }
    
    return types;
}

@end
