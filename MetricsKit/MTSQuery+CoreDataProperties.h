//
//  MTSQuery+CoreDataProperties.h
//  Metrics
//
//  Created by Daniel Strokis on 3/26/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSQuery+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MTSQuery (CoreDataProperties)

+ (NSFetchRequest<MTSQuery *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *startDate;
@property (nullable, nonatomic, copy) NSDate *endDate;
@property (nullable, nonatomic, retain) NSSet *quantityTypes;
@property (nullable, nonatomic, retain) MTSGraph *graph;

@end

NS_ASSUME_NONNULL_END
