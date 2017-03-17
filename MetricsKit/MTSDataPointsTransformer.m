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
    return [NSSet class];
}


- (id)transformedValue:(id)value {
    if (![value isKindOfClass:[NSSet class]]) {
        return nil;
    }
    
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}


- (id)reverseTransformedValue:(id)value {
    id reversed = [NSKeyedUnarchiver unarchiveObjectWithData:value];
    
    if (![reversed isKindOfClass:[NSSet class]]) {
        return nil;
    }
    
    return reversed;
}

@end
