//
//  MTSGraphCreationViewController.m
//  Metrics
//
//  Created by Daniel Strokis on 2/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphCreationViewController.h"

@interface MTSGraphCreationViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic) NSManagedObjectContext *context;

@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) UITextField *activeTextField;

@property (nonatomic) NSArray <HKQuantityTypeIdentifier>*selectedHealthTypes;
@property (nonatomic) NSDictionary <HKQuantityTypeIdentifier, NSString *> *healthTypeNameLookup;
@property (nonatomic) UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *timeUnitSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *startDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *endDateTextField;

@end

@implementation MTSGraphCreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSelectedHealthTypes:[[[[self graph] query] quantityTypes] allObjects]];
    [self setHealthTypeNameLookup:MTSQuantityTypeIdentifiers()];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                               fromDate:date];
    
    [self setEndDate:[calendar dateFromComponents:components]];
    [self setStartDate:[calendar dateByAddingUnit:NSCalendarUnitDay
                                          value:-1
                                         toDate:[self endDate]
                                        options:NSCalendarWrapComponents]];
    
    UIDatePicker *picker = [UIDatePicker new];
    [picker setMaximumDate:date];
    [picker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    [self setDatePicker:picker];
    
    [[self startDateTextField] setInputView:picker];
    [[self endDateTextField] setInputView:picker];
    
    [self updateTextField:[self startDateTextField] withDate:[self startDate]];
    [self updateTextField:[self endDateTextField] withDate:[self endDate]];
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [NSDateFormatter new];
        [_dateFormatter setDateFormat:@"MMM dd, yyyy"];
        [_dateFormatter setLocale:[NSLocale currentLocale]];
    }
    
    return _dateFormatter;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MTSQuery *query = [[self graph] query];
    [query setStartDate: [self startDate]];
    [query setEndDate:[self endDate]];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[[self graph] query] quantityTypes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"healthDataCell"];
    
    HKQuantityTypeIdentifier key = [[self selectedHealthTypes] objectAtIndex:[indexPath row]];
    NSString *value = [[self healthTypeNameLookup] objectForKey:key];
    
    [[cell textLabel] setText:value];
    
    return cell;
}

#pragma mark - UIDatePicker event handler

- (IBAction)datePickerDidChangeValue:(UIDatePicker *)sender {
    NSDate *selectedDate = [sender date];
    UITextField *activeTextField = [self activeTextField];
    
    [self updateTextField:activeTextField withDate:selectedDate];
    
    if ([activeTextField isEqual:[self startDateTextField]]) {
        [self setStartDate:selectedDate];
    } else if ([activeTextField isEqual:[self endDateTextField]]) {
        [self setEndDate:selectedDate];
    }
}

#pragma mark - UISegmentedControl event handler
- (IBAction)timeUnitDidChange:(UISegmentedControl *)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            [[self datePicker] setDatePickerMode:UIDatePickerModeDateAndTime];
            break;
        case 1: // fallthrough
        case 2:
            [[self datePicker] setDatePickerMode:UIDatePickerModeDate];
            break;
        default:
            break;
    }
    
    // update text fields
}


#pragma mark UITextField
-(void)dateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)self.activeTextField.inputView;
    NSDate *eventDate = picker.date;
    
    if ([[self activeTextField] isEqual:[self endDateTextField]]) {
        [self setEndDate:eventDate];
    } else {
        [self setStartDate:eventDate];
    }
    
    NSString *dateString = [self.dateFormatter stringFromDate:eventDate];
    self.activeTextField.text = [NSString stringWithFormat:@"%@",dateString];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
    return YES;
}

- (void)updateTextField:(UITextField *)textField withDate:(NSDate *)date {
    NSString *formattedDate = [self.dateFormatter stringFromDate:date];
    [textField setText:formattedDate];
}

@end
