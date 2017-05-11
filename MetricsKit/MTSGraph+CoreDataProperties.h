//
//  MTSGraph+CoreDataProperties.h
//  Metrics
//
//  Created by Daniel Strokis on 5/11/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraph+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MTSGraph (CoreDataProperties)

+ (NSFetchRequest<MTSGraph *> *)fetchRequest;

@property (nullable, nonatomic, retain) UIColor *bottomColor;
@property (nonatomic) BOOL drawsIntermediateLines;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, retain) UIColor *topColor;
@property (nullable, nonatomic, copy) NSString *xAxisTitle;
@property (nullable, nonatomic, copy) NSString *yAxisTitle;
@property (nullable, nonatomic, copy) NSDate *endDate;
@property (nullable, nonatomic, copy) NSDate *startDate;
@property (nullable, nonatomic, retain) NSSet<MTSQuery *> *queries;

@end

@interface MTSGraph (CoreDataGeneratedAccessors)

- (void)addQueriesObject:(MTSQuery *)value;
- (void)removeQueriesObject:(MTSQuery *)value;
- (void)addQueries:(NSSet<MTSQuery *> *)values;
- (void)removeQueries:(NSSet<MTSQuery *> *)values;

@end

NS_ASSUME_NONNULL_END
