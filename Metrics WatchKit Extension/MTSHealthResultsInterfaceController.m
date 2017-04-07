//
//  MTSHealthResultsInterfaceController.m
//  Metrics
//
//  Created by Daniel Strokis on 3/22/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSHealthResultsInterfaceController.h"

@implementation MTSHealthResultsTableRowController
@end

@interface MTSHealthResultsInterfaceController ()

@property NSDateFormatter *dateFormatter;

@end

@implementation MTSHealthResultsInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    NSDictionary *contextDict = (NSDictionary *)context;
    
    HKQuantityTypeIdentifier identifier = (HKQuantityTypeIdentifier)[contextDict objectForKey:@"identifier"];
    HKHealthStore *healthStore = (HKHealthStore *)[contextDict objectForKey:@"healthStore"];
    NSString *name = (NSString *)[contextDict objectForKey:@"name"];
    
    [[self typeInterfaceLabel] setText:name];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *startDate = [calendar startOfDayForDate:now];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    __weak MTSHealthResultsInterfaceController *this = self;
    
    [MTSHealthStoreManager queryHealthStore:healthStore
                               forQuantityType:identifier
                                      fromDate:startDate
                                        toDate:endDate
                        usingCompletionHandler:^(NSArray<MTSQuantitySample *> * _Nullable samples) {
                            [this configureInterfaceTable:this.resultsInterfaceTable WithHealthSamples:samples];
                        }];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setCalendar:[NSCalendar currentCalendar]];
    [self setDateFormatter:formatter];
}

- (void)configureInterfaceTable:(WKInterfaceTable *)table WithHealthSamples:(NSArray<MTSQuantitySample *> *)samples {
    NSInteger rowNumber = [samples count];
    if (rowNumber == 0) {
        return;
    }
    
    [table setNumberOfRows:rowNumber withRowType:@"HealthDataSampleRow"];
    
    NSString *unit = [[samples objectAtIndex:0] unit];
    [[self unitsInterfaceLabel] setText:unit];
    
    for (NSInteger i = 0; i < rowNumber; i++) {
        MTSHealthResultsTableRowController *controller = [table rowControllerAtIndex:i];
        MTSQuantitySample *sample = [samples objectAtIndex:i];
        
        NSDate *date = [sample date];
        [[controller sampleDateLabel] setText:[[self dateFormatter] stringFromDate:date]];
        
        NSNumber *amount = [sample amount];
        [[controller sampleAmountLabel] setText:[NSString stringWithFormat:@"%.0f", [amount doubleValue]]];
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



