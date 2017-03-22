//
//  InterfaceController.h
//  Metrics WatchKit Extension
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

@import WatchKit;
@import Foundation;

#import <MetricsKit/MetricsKit.h>

@interface InterfaceController : WKInterfaceController

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *healthLabelsInterfaceTable;

@end

@interface MTSHealthLabelRowController : NSObject

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *healthTypeLabel;

@end
