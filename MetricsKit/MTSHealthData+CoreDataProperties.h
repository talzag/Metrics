//
//  MTSHealthData+CoreDataProperties.h
//  Metrics
//
//  Created by Daniel Strokis on 3/17/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSHealthData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MTSHealthData (CoreDataProperties)

+ (NSFetchRequest<MTSHealthData *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *label;
@property (nullable, nonatomic, copy) NSString *identifier;
@property (nullable, nonatomic, copy) NSNumber *type;

@end

NS_ASSUME_NONNULL_END
