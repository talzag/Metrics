//
//  MTSDataPointsTransformer.m
//  Metrics
//
//  Created by Daniel Strokis on 2/21/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSDataPointsTransformer.h"

@implementation MTSDataPointsTransformer

+ (BOOL)allowsReverseTransformation {
    return YES;
}


+ (Class)transformedValueClass {
    return [NSArray class];
}


- (id)transformedValue:(id)value {
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}


- (id)reverseTransformedValue:(id)value {
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end
