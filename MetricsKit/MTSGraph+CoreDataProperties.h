//
//  MTSGraph+CoreDataProperties.h
//  Metrics
//
//  Created by Daniel Strokis on 4/9/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraph+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MTSGraph (CoreDataProperties)

+ (NSFetchRequest<MTSGraph *> *)fetchRequest;

@property (nullable, nonatomic, retain) HKHealthStore *healthStore;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, retain) NSData *topColor;
@property (nullable, nonatomic, retain) NSData *bottomColor;
@property (nullable, nonatomic, retain) MTSQuery *query;

@end

NS_ASSUME_NONNULL_END
