//
//  MTSQuantityTypeIdentifiers.h
//  Metrics
//
//  Created by Daniel Strokis on 3/17/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#ifndef MTSQuantityTypeIdentifiers_h
#define MTSQuantityTypeIdentifiers_h

NSArray <NSDictionary *>*MTSQuantityTypeHealthCategories(void);

NSDictionary <NSString *, HKQuantityTypeIdentifier> *MTSQuantityTypeIdentifiers(void);

NSDictionary <NSString *, HKQuantityTypeIdentifier> *MTSQuantityTypeBodyMeasurementIdentifiers(void);

NSDictionary <NSString *, HKQuantityTypeIdentifier> *MTSQuantityTypeFitnessIdentifiers(void);

NSDictionary <NSString *, HKQuantityTypeIdentifier> *MTSQuantityTypeVitalsIdentifiers(void);

NSDictionary <NSString *, HKQuantityTypeIdentifier> *MTSQuantityTypeResultsIdentifiers(void);

NSDictionary <NSString *, HKQuantityTypeIdentifier> *MTSQuantityTypeNutritionIdentifiers(void);

#endif /* MTSQuantityTypeIdentifiers_h */
