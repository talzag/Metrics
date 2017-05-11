//
//  MTSQuery+CoreDataProperties.h
//  Metrics
//
//  Created by Daniel Strokis on 5/11/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSQuery+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MTSQuery (CoreDataProperties)

+ (NSFetchRequest<MTSQuery *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *healthKitTypeIdentifier;
@property (nullable, nonatomic, copy) NSString *healthTypeDisplayName;
@property (nullable, nonatomic, retain) UIColor *lineColor;
@property (nullable, nonatomic, retain) NSArray *fetchedDataPoints;
@property (nullable, nonatomic, retain) MTSGraph *graph;

@end

NS_ASSUME_NONNULL_END
