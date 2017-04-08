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

NSDictionary <HKQuantityTypeIdentifier, NSString *> *MTSQuantityTypeIdentifiers(void);

NSDictionary <HKQuantityTypeIdentifier, NSString *> *MTSQuantityTypeBodyMeasurementIdentifiers(void);

NSDictionary <HKQuantityTypeIdentifier, NSString *> *MTSQuantityTypeFitnessIdentifiers(void);

NSDictionary <HKQuantityTypeIdentifier, NSString *> *MTSQuantityTypeVitalsIdentifiers(void);

NSDictionary <HKQuantityTypeIdentifier, NSString *> *MTSQuantityTypeResultsIdentifiers(void);

NSDictionary <HKQuantityTypeIdentifier, NSString *> *MTSQuantityTypeNutritionIdentifiers(void);

#endif /* MTSQuantityTypeIdentifiers_h */
