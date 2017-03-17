//
//  MTSHealthData+CoreDataProperties.m
//  Metrics
//
//  Created by Daniel Strokis on 3/17/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSHealthData+CoreDataProperties.h"

@implementation MTSHealthData (CoreDataProperties)

+ (NSFetchRequest<MTSHealthData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MTSHealthData"];
}

@dynamic label;
@dynamic identifier;
@dynamic type;

@end
