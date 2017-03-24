//
//  InterfaceController.m
//  Metrics WatchKit Extension
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "InterfaceController.h"

@implementation MTSHealthLabelRowController
@end

@interface InterfaceController()

@property NSDictionary <NSString *, HKQuantityTypeIdentifier> *healthLabels;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    WKInterfaceTable *table = [self healthLabelsInterfaceTable];
    
    [self setHealthLabels:MTSQuantityTypeIdentifiers()];
    NSUInteger number = [[self healthLabels] count];
    [table setNumberOfRows:number withRowType:@"HealthTypeLabelRow"];
    
    NSArray <NSString *>*readableNames = [[self healthLabels] allKeys];
    
    NSInteger i;
    for (i = 0; i < number; i++) {
        MTSHealthLabelRowController *rowController = [table rowControllerAtIndex:i];
        NSString *name = [readableNames objectAtIndex:i];
        [[rowController healthTypeLabel] setText:name];
    }
}

- (void)willActivate {
    
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex {
    NSString *name = [[[self healthLabels] allKeys] objectAtIndex:rowIndex];
    HKQuantityTypeIdentifier identifier = [[self healthLabels] objectForKey:name];
    
    return @{
             @"healthStore": [self healthStore],
             @"identifier": identifier,
             @"name": name
             };
}

@end



