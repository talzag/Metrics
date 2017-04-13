//
//  MTSColorTransformer.m
//  Metrics
//
//  Created by Daniel Strokis on 4/8/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSColorTransformer.h"

@implementation MTSColorTransformer

+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return [MTSColorBox class];
}

- (id)transformedValue:(id)value {
    if (![value isKindOfClass:[MTSColorBox class]]) {
        return nil;
    }
    
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (id)reverseTransformedValue:(id)value {
    id reversed = [NSKeyedUnarchiver unarchiveObjectWithData:value];
    
    if (![reversed isKindOfClass:[MTSColorBox class]]) {
        return nil;
    }
    
    return reversed;
}


@end
