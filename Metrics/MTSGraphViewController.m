//
//  MTSGraphViewController.m
//  Metrics
//
//  Created by Daniel Strokis on 2/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphViewController.h"
#import "MTSGraph+HKQuery.h"

@interface MTSGraphViewController ()
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

@end

@implementation MTSGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.graph.title;
    // TODO: Use NSDateFormatter here
    self.startDateLabel.text = self.graph.startDate.description;
    self.endDateLabel.text = self.graph.endDate.description;
    self.graphView.dataPoints = self.graph.dataPoints;
    
    [self.graph populateGraphDataByQueryingHealthStore:self.healthStore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
