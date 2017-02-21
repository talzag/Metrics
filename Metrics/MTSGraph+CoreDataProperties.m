//
//  MTSGraph+CoreDataProperties.m
//  Metrics
//
//  Created by Daniel Strokis on 2/21/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "MTSGraph+CoreDataProperties.h"

@implementation MTSGraph (CoreDataProperties)

+ (NSFetchRequest<MTSGraph *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MTSGraph"];
}

@dynamic title;
@dynamic yAxisTitle;
@dynamic xAxisTitle;
@dynamic dataPoints;
@dynamic startDate;
@dynamic endDate;
@dynamic xAxisLabels;

@end
