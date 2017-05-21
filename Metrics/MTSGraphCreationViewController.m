//
//  MTSGraphCreationViewController.m
//  Metrics
//
//  Created by Daniel Strokis on 2/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphCreationViewController.h"
#import "MTSColorPickerTableViewCell.h"

@interface MTSGraphCreationViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic) NSManagedObjectContext *context;

@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) UITextField *activeTextField;

@property (nonatomic) NSArray *graphQueries;
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
    
    [self setGraphQueries:[[[self graph] queries] allObjects]];
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

    
    NSString *formattedStartDate = [self.dateFormatter stringFromDate:[self startDate]];
    NSString *formattedEndDate = [[self dateFormatter] stringFromDate:[self endDate]];
    [[self startDateTextField] setText:formattedStartDate];
    [[self endDateTextField] setText:formattedEndDate];
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
    [[self graph] setStartDate:[self startDate]];
    [[self graph] setEndDate:[self endDate]];
    
    NSArray *queries = [self graphQueries];
    NSInteger i;
    for (i = 0; i < [queries count]; i++) {
        MTSQuery *query = [queries objectAtIndex:i];
        
        NSIndexPath*indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        MTSColorPickerTableViewCell *cell = [[self tableView] cellForRowAtIndexPath: indexPath];
        
        UIColor *selectedColor = [[cell colorSwatchView] backgroundColor];
        [query setLineColor:selectedColor];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self graphQueries] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MTSColorPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"healthDataCell"];
    
    MTSQuery *query = [[self graphQueries] objectAtIndex:[indexPath row]];
    NSString *value = [[self healthTypeNameLookup] objectForKey:[query healthKitTypeIdentifier]];
    
    [[cell textLabel] setText:value];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - UISegmentedControl event handler

- (IBAction)timeUnitDidChange:(UISegmentedControl *)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0: // Hourly
            [[self datePicker] setDatePickerMode:UIDatePickerModeTime];
            break;
        case 1: // Daily
            [[self datePicker] setDatePickerMode:UIDatePickerModeDate];
            break;
        default:
            break;
    }
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
    if (![[textField inputView] isKindOfClass:[UIDatePicker class]]) {
        return NO;
    }
    
    self.activeTextField = textField;
    
    UIDatePicker *picker = (UIDatePicker *)self.activeTextField.inputView;
    if ([textField isEqual:[self endDateTextField]]){
        [picker setMinimumDate:[self startDate]];
        [picker setDate:[self endDate] animated:YES];
    } else {
        [picker setDate:[self startDate] animated:YES];
    }
    
    return YES;
}

@end
