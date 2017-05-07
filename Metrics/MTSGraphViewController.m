//
//  MTSGraphViewController.m
//  Metrics
//
//  Created by Daniel Strokis on 2/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphViewController.h"

@interface MTSGraphViewController ()

@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation MTSGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationItem] setTitle:[[self graph] title]];
    [[self startDateLabel] setText:[[self dateFormatter] stringFromDate:[[[self graph] query] startDate]]];
    [[self endDateLabel] setText:[[self dateFormatter] stringFromDate:[[[self graph] query] endDate]]];
    
    MTSGraph *graph = [self graph];
    [graph executeQueryWithHealthStore:[self healthStore]
                usingCompletionHandler:^(NSArray * _Nullable dataPoints, NSError * _Nullable error) {
                    if (!error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[self graphView] setDataPoints:dataPoints];
                        });
                    }
                }];
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"MMM dd, yyyy" ];
        [_dateFormatter setLocale:[NSLocale currentLocale]];
    }
    return _dateFormatter;
}

@end
