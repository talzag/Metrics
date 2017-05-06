//
//  MTSQueryDataConfiguration+CoreDataProperties.h
//  Metrics
//
//  Created by Daniel Strokis on 5/6/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSQueryDataConfiguration+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MTSQueryDataConfiguration (CoreDataProperties)

+ (NSFetchRequest<MTSQueryDataConfiguration *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *healthTypeDisplayName;
@property (nullable, nonatomic, retain) MTSColorBox *lineColor;
@property (nullable, nonatomic, retain) NSArray *fetchedDataPoints;
@property (nullable, nonatomic, copy) NSString *healthKitTypeIdentifier;

@end

NS_ASSUME_NONNULL_END
