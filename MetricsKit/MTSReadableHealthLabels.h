//
//  MTSReadableHealthLabels.h
//  Metrics
//
//  Created by Daniel Strokis on 3/17/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#ifndef MTSReadableHealthLabels_h
#define MTSReadableHealthLabels_h

NSDictionary <NSString *, HKQuantityTypeIdentifier> *MTSNutritionIdentifiers(void);
NSDictionary <NSString *, HKQuantityTypeIdentifier> *MTSBodyMeasurementIdentifiers(void);
NSDictionary <NSString *, HKQuantityTypeIdentifier> *MTSFitnessIdentifiers(void);
NSDictionary <NSString *, HKQuantityTypeIdentifier> *MTSVitalsIdentifiers(void);
NSDictionary <NSString *, HKQuantityTypeIdentifier> *MTSResultsIdentifiers(void);

#endif /* MTSReadableHealthLabels_h */
