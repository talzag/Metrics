//
//  MTSGraph+CoreDataProperties.m
//  Metrics
//
//  Created by Daniel Strokis on 2/28/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraph+CoreDataProperties.h"

@implementation MTSGraph (CoreDataProperties)

+ (NSFetchRequest<MTSGraph *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MTSGraph"];
}

@dynamic dataPoints;
@dynamic endDate;
@dynamic quantityHealthTypeIdentifiers;
@dynamic startDate;
@dynamic title;
@dynamic xAxisLabels;
@dynamic xAxisTitle;
@dynamic yAxisTitle;
@dynamic categoryHealthTypeIdentifiers;

@end
