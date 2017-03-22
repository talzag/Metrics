//
//  MTSHealthResultsInterfaceController.m
//  Metrics
//
//  Created by Daniel Strokis on 3/22/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSHealthResultsInterfaceController.h"

@interface MTSHealthResultsInterfaceController ()

@end

@implementation MTSHealthResultsInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    NSDictionary *contextDict = (NSDictionary *)context;
    HKQuantityTypeIdentifier identifier = (HKQuantityTypeIdentifier)[contextDict objectForKey:@"identifier"];
    HKHealthStore *healthStore = (HKHealthStore *)[contextDict objectForKey:@"healthStore"];
    NSString *name = (NSString *)[contextDict objectForKey:@"name"];
    [self setTitle:name];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *startDate = [calendar startOfDayForDate:now];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    __weak MTSHealthResultsInterfaceController *this = self;
    [MTSHealthDataCoordinator queryHealthStore:healthStore
                               forQuantityType:identifier
                                      fromDate:startDate
                                        toDate:endDate
                        usingCompletionHandler:^(NSArray<__kindof HKSample *> * _Nullable samples) {
                            [this configureInterfaceTableWithHealthSamples:samples];
                        }];
}

- (void)configureInterfaceTableWithHealthSamples:(NSArray<__kindof HKSample *> *)samples {
    
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



