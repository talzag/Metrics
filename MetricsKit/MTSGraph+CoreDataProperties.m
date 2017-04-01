//
//  MTSGraph+CoreDataProperties.m
//  Metrics
//
//  Created by Daniel Strokis on 4/1/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraph+CoreDataProperties.h"

@implementation MTSGraph (CoreDataProperties)

+ (NSFetchRequest<MTSGraph *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MTSGraph"];
}

@dynamic title;
@dynamic query;

@end
