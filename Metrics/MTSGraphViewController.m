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

@property (nonatomic) NSArray <NSDictionary <NSString *, id> *> *sectionData;

@end

@implementation MTSGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.graph.title;
    self.startDateLabel.text = [[self dateFormatter] stringFromDate:[[self graph] startDate]];
    self.endDateLabel.text = [[self dateFormatter] stringFromDate:[[self graph] endDate]];
    self.graphView.dataPoints = self.graph.dataPoints;
    
    [self.graph populateGraphDataByQueryingHealthStore:self.healthStore completionHandler:nil];
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

- (NSArray *)sectionData {
    if (!_sectionData) {
        _sectionData = [[[self graph] dataPoints] allObjects];
    }
    
    return _sectionData;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self sectionData] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sectionData = [[self sectionData] objectAtIndex:section];
    NSArray *dataPoints = [sectionData objectForKey:MTSGraphDataPointsKey];
    
    return [dataPoints count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataCell"];
    
    NSString *title = [NSString stringWithFormat:@"Sample %ld", (long)[indexPath row] + 1];
    [[cell textLabel] setText:title];
    
    NSDictionary *sectionData = [[self sectionData] objectAtIndex:[indexPath section]];
    NSArray *dataPoints = [sectionData objectForKey:MTSGraphDataPointsKey];
    NSNumber *datum = [dataPoints objectAtIndex:[indexPath row]];
    NSString *value = [NSString stringWithFormat:@"%2.1f", [datum doubleValue]];
    [[cell detailTextLabel] setText:value];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    __block NSString *headerTitle;
    
    NSDictionary *data = [[self sectionData] objectAtIndex:section];
    HKQuantityTypeIdentifier ident = [data objectForKey:MTSGraphDataIdentifierKey];
    [self.quantityTypeIdentifiers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, HKQuantityTypeIdentifier  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:ident]) {
            headerTitle = key;
            *stop = YES;
        }
    }];
    
    return headerTitle;
}

@end
