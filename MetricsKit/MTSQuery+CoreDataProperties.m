//
//  MTSQuery+CoreDataProperties.m
//  Metrics
//
//  Created by Daniel Strokis on 3/26/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSQuery+CoreDataProperties.h"

@implementation MTSQuery (CoreDataProperties)

+ (NSFetchRequest<MTSQuery *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MTSQuery"];
}

@dynamic startDate;
@dynamic endDate;
@dynamic quantityTypes;
@dynamic graph;

@end
