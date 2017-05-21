//
//  MTSGraph+CoreDataProperties.m
//  Metrics
//
//  Created by Daniel Strokis on 5/21/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraph+CoreDataProperties.h"

@implementation MTSGraph (CoreDataProperties)

+ (NSFetchRequest<MTSGraph *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MTSGraph"];
}

@dynamic bottomColor;
@dynamic drawsIntermediateLines;
@dynamic endDate;
@dynamic startDate;
@dynamic title;
@dynamic topColor;
@dynamic xAxisTitle;
@dynamic yAxisTitle;
@dynamic xAxisLabels;
@dynamic yAxisLabels;
@dynamic queryInterval;
@dynamic queries;

@end
