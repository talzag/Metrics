//
//  MTSQueryDataConfiguration+CoreDataProperties.m
//  Metrics
//
//  Created by Daniel Strokis on 5/7/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSQueryDataConfiguration+CoreDataProperties.h"

@implementation MTSQueryDataConfiguration (CoreDataProperties)

+ (NSFetchRequest<MTSQueryDataConfiguration *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MTSQueryDataConfiguration"];
}

@dynamic fetchedDataPoints;
@dynamic healthKitTypeIdentifier;
@dynamic healthTypeDisplayName;
@dynamic lineColor;
@dynamic query;

@end
