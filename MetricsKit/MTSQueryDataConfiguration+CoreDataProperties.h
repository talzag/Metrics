//
//  MTSQueryDataConfiguration+CoreDataProperties.h
//  Metrics
//
//  Created by Daniel Strokis on 5/7/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSQueryDataConfiguration+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MTSQueryDataConfiguration (CoreDataProperties)

+ (NSFetchRequest<MTSQueryDataConfiguration *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSArray *fetchedDataPoints;
@property (nullable, nonatomic, copy) NSString *healthKitTypeIdentifier;
@property (nullable, nonatomic, copy) NSString *healthTypeDisplayName;
@property (nullable, nonatomic, retain) UIColor *lineColor;
@property (nullable, nonatomic, retain) MTSQuery *query;

@end

NS_ASSUME_NONNULL_END
