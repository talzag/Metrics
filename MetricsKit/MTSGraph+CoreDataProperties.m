//
//  MTSGraph+CoreDataProperties.m
//  Metrics
//
//  Created by Daniel Strokis on 4/9/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraph+CoreDataProperties.h"

@implementation MTSGraph (CoreDataProperties)

+ (NSFetchRequest<MTSGraph *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MTSGraph"];
}

@dynamic healthStore;
@dynamic title;
@dynamic topColor;
@dynamic bottomColor;
@dynamic query;

@end
