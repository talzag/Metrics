//
//  MTSHealthResultsInterfaceController.h
//  Metrics
//
//  Created by Daniel Strokis on 3/22/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import WatchKit;
@import Foundation;
@import HealthKit;

#import <MetricsKit/MetricsKit.h>

@interface MTSHealthResultsInterfaceController : WKInterfaceController

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *resultsInterfaceTable;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *unitsInterfaceLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *typeInterfaceLabel;

@end

@interface MTSHealthResultsTableRowController : NSObject

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *sampleDateLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *sampleAmountLabel;


@end
