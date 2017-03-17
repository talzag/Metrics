//
//  MTSGraph+CoreDataProperties.h
//  Metrics
//
//  Created by Daniel Strokis on 3/17/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraph+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MTSGraph (CoreDataProperties)

+ (NSFetchRequest<MTSGraph *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSSet *categoryHealthTypeIdentifiers;
@property (nullable, nonatomic, retain) NSSet *dataPoints;
@property (nullable, nonatomic, copy) NSDate *endDate;
@property (nullable, nonatomic, retain) NSSet *quantityHealthTypeIdentifiers;
@property (nullable, nonatomic, copy) NSDate *startDate;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *xAxisLabels;
@property (nullable, nonatomic, copy) NSString *xAxisTitle;
@property (nullable, nonatomic, copy) NSString *yAxisTitle;

@end

NS_ASSUME_NONNULL_END
