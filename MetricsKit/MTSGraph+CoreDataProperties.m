//
//  MTSGraph+CoreDataProperties.m
//  Metrics
//
//  Created by Daniel Strokis on 5/11/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraph+CoreDataProperties.h"

@implementation MTSGraph (CoreDataProperties)

+ (NSFetchRequest<MTSGraph *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MTSGraph"];
}

@dynamic bottomColor;
@dynamic drawsIntermediateLines;
@dynamic title;
@dynamic topColor;
@dynamic xAxisTitle;
@dynamic yAxisTitle;
@dynamic endDate;
@dynamic startDate;
@dynamic queries;

@end
