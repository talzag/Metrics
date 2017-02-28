//
//  MTSGraph+CoreDataProperties.h
//  Metrics
//
//  Created by Daniel Strokis on 2/28/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraph+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MTSGraph (CoreDataProperties)

+ (NSFetchRequest<MTSGraph *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSArray *dataPoints;
@property (nullable, nonatomic, copy) NSDate *endDate;
@property (nullable, nonatomic, copy) NSDate *startDate;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *xAxisLabels;
@property (nullable, nonatomic, copy) NSString *xAxisTitle;
@property (nullable, nonatomic, copy) NSString *yAxisTitle;
@property (nullable, nonatomic, retain) NSSet *healthTypes;

@end

NS_ASSUME_NONNULL_END
