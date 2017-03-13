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
@property (nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation MTSGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.graph.title;
    self.startDateLabel.text = [[self dateFormatter] stringFromDate:[[self graph] startDate]];
    self.endDateLabel.text = [[self dateFormatter] stringFromDate:[[self graph] endDate]];
    self.graphView.dataPoints = self.graph.dataPoints;
    
    [self.graph populateGraphDataByQueryingHealthStore:self.healthStore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"MMM dd, yyyy";
        _dateFormatter.locale = [NSLocale currentLocale];
    }
    return _dateFormatter;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[self graph] dataPoints] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sectionData = [[[[self graph] dataPoints] allObjects] objectAtIndex:section];
    NSArray *dataPoints = [sectionData objectForKey:MTSGraphDataPointsKey];
    
    return [dataPoints count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataCell"];
    
    return cell;
}

@end
