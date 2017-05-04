//
//  MTSQuery+CoreDataProperties.m
//  Metrics
//
//  Created by Daniel Strokis on 5/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSQuery+CoreDataProperties.h"

@implementation MTSQuery (CoreDataProperties)

+ (NSFetchRequest<MTSQuery *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MTSQuery"];
}

@dynamic endDate;
@dynamic dataTypeConfigurations;
@dynamic startDate;
@dynamic graph;

@end
