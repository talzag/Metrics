//
//  MTSGraphCreationViewController.m
//  Metrics
//
//  Created by Daniel Strokis on 2/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphCreationViewController.h"


@interface MTSGraphCreationViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) UITextField *activeTextField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *startDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *endDateTextField;

@end

@implementation MTSGraphCreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.selectedHealthTypes = [NSMutableSet set];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                               fromDate:date];
    
    self.endDate = [calendar dateFromComponents:components];
    self.startDate = [calendar dateByAddingUnit:NSCalendarUnitDay
                                          value:-1
                                         toDate:[self endDate]
                                        options:NSCalendarWrapComponents];
    
    self.startDateTextField.text = [self.dateFormatter stringFromDate:self.startDate];
    self.endDateTextField.text = [self.dateFormatter stringFromDate:self.endDate];
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateFormat = @"MMM dd, yyyy";
        _dateFormatter.locale = [NSLocale currentLocale];
    }
    
    return _dateFormatter;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // create graph here
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self query] quantityTypes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    
    
    
    return cell;
}

#pragma mark - UIDatePicker event handler
- (IBAction)datePickerDidChangeValue:(UIDatePicker *)sender {
    NSDate *selectedDate = sender.date;
    NSString *formattedDate = [self.dateFormatter stringFromDate:selectedDate];
    self.activeTextField.text = formattedDate;
    
    if ([self.activeTextField isEqual:self.startDateTextField]) {
        self.startDate = selectedDate;
    } else if ([self.activeTextField isEqual:self.endDateTextField]) {
        self.endDate = selectedDate;
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

@end
