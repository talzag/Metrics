//
//  MTSQuery+CoreDataProperties.h
//  Metrics
//
//  Created by Daniel Strokis on 5/7/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSQuery+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MTSQuery (CoreDataProperties)

+ (NSFetchRequest<MTSQuery *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *endDate;
@property (nullable, nonatomic, copy) NSDate *startDate;
@property (nullable, nonatomic, retain) MTSGraph *graph;
@property (nullable, nonatomic, retain) NSSet<MTSQueryDataConfiguration *> *dataTypeConfigurations;

@end

@interface MTSQuery (CoreDataGeneratedAccessors)

- (void)addDataTypeConfigurationsObject:(MTSQueryDataConfiguration *)value;
- (void)removeDataTypeConfigurationsObject:(MTSQueryDataConfiguration *)value;
- (void)addDataTypeConfigurations:(NSSet<MTSQueryDataConfiguration *> *)values;
- (void)removeDataTypeConfigurations:(NSSet<MTSQueryDataConfiguration *> *)values;

@end

NS_ASSUME_NONNULL_END
