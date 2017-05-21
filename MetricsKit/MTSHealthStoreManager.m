//
//  MTSHealthDataCoordinator.m
//  Metrics
//
//  Created by Daniel Strokis on 3/15/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSHealthStoreManager.h"
#import "MTSQuantityTypeIdentifiers.h"

@implementation MTSHealthStoreManager

+ (void)requestReadAccessForHealthStore:(HKHealthStore *)healthStore
                      completionHandler:(void (^ _Nonnull)(BOOL, NSError * _Nullable))completionHandler {
    NSMutableSet *readTypes = [NSMutableSet set];
    
    NSDictionary <HKQuantityTypeIdentifier, NSString *> *identifiers = MTSQuantityTypeIdentifiers();
    [identifiers enumerateKeysAndObjectsUsingBlock:^(HKQuantityTypeIdentifier _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [readTypes addObject:[HKObjectType quantityTypeForIdentifier:key]];
    }];
    
    NSSet *shareTypes;
    
#ifdef TESTING
    HKQuantityType *activeEnergy = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *dietaryEnery = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    HKQuantityType *baseEnergy = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned];
    
    shareTypes =  [NSSet setWithObjects:activeEnergy, dietaryEnery, baseEnergy, nil];
#endif
    
    [healthStore requestAuthorizationToShareTypes:shareTypes readTypes:readTypes completion:^(BOOL success, NSError * _Nullable error) {
        completionHandler(success, error);
    }];
}

@end
