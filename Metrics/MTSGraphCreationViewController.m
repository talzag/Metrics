//
//  MTSGraphCreationViewController.m
//  Metrics
//
//  Created by Daniel Strokis on 2/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphCreationViewController.h"

static NSString * const HealthIdentifierCell = @"HealthIdentifierCell";

@interface MTSGraphCreationViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray <NSString *>*quantityNames;
@property (strong, nonatomic) NSMutableSet <HKQuantityTypeIdentifier>*selectedHealthTypes;

@property (nonatomic) UIView *datePickerContainer;
@property (nonatomic) UIDatePicker *datePicker;
@property (nonatomic) NSDateFormatter *dateFormatter;
@property UITextField *activeTextField;

@property NSDate *startDate;
@property NSDate *endDate;

@property NSDictionary <NSString *, HKQuantityTypeIdentifier>*quantityTypeIdentifiers;

@end

@implementation MTSGraphCreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setQuantityTypeIdentifiers:MTSQuantityTypeIdentifiers()];
    
    self.quantityNames = [self.quantityTypeIdentifiers.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull key1, NSString *  _Nonnull key2) {
        return [key1 localizedStandardCompare:key2];
    }];
    
    self.selectedHealthTypes = [NSMutableSet set];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    self.endDate = [calendar dateFromComponents:components];
    self.startDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:self.endDate options:NSCalendarWrapComponents];
    
    self.startDateTextField.text = [self.dateFormatter stringFromDate:self.startDate];
    self.endDateTextField.text = [self.dateFormatter stringFromDate:self.endDate];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(displayDatePickerContainer:)
                               name:UIKeyboardDidHideNotification
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(deviceOrientationDidChange:)
                               name:UIDeviceOrientationDidChangeNotification
                             object:nil];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    [super viewDidDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.graph.title = self.graphTitleTextField.text;
    self.graph.startDate = self.startDate;
    self.graph.endDate = self.endDate;
    self.graph.quantityHealthTypeIdentifiers = [NSSet setWithSet:self.selectedHealthTypes];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"MMM dd, yyyy";
        _dateFormatter.locale = [NSLocale currentLocale];
    }
    return _dateFormatter;
}

// FIXME: Need to take into account that a users' device could rotate & adjust picker container size/frame accordingly
- (UIView *)datePickerContainer {
    if (!_datePickerContainer) {
        CGRect frame = CGRectMake(0,
                                  CGRectGetMaxY(self.view.frame),
                                  self.view.frame.size.width,
                                  self.view.frame.size.height * 0.4);
        
        _datePickerContainer = [[UIView alloc] initWithFrame:frame];
        _datePickerContainer.backgroundColor = [UIColor whiteColor];
        
        CGRect stackViewFrame = CGRectInset(frame, 8.0, 8.0);
        stackViewFrame.origin = CGPointMake(8.0, 0.0);
        UIStackView *stackView = [[UIStackView alloc] initWithFrame:stackViewFrame];
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.alignment = UIStackViewAlignmentTrailing;
        stackView.spacing = 8.0;
        stackView.distribution = UIStackViewDistributionFillProportionally;
        
        UILayoutGuide *stackViewMargins = stackView.layoutMarginsGuide;
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(dismissDatePickerContainer:) forControlEvents:UIControlEventTouchUpInside];
        [stackView addArrangedSubview:doneButton];
        
        // grab default tint color here
        UIColor *defaultTintColor = doneButton.tintColor;
        [doneButton setTintColor:[UIColor whiteColor]];
        
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.maximumDate = [NSDate date];
        
        [stackView addArrangedSubview:_datePicker];
        [_datePicker.leadingAnchor constraintEqualToAnchor:stackViewMargins.leadingAnchor].active = YES;
        [_datePicker.trailingAnchor constraintEqualToAnchor:stackViewMargins.trailingAnchor].active = YES;
        [_datePicker addTarget:self action:@selector(datePickerDidChangeValue:) forControlEvents:UIControlEventValueChanged];
        
        CGRect barFrame = CGRectMake(0,
                                     0,
                                     _datePickerContainer.frame.size.width,
                                     doneButton.intrinsicContentSize.height);
        UIView *bar = [[UIView alloc] initWithFrame:barFrame];
        
        // Set background to default tint color here
        bar.backgroundColor = defaultTintColor;
        
        [_datePickerContainer addSubview:bar];
        [_datePickerContainer addSubview:stackView];
        
        [self.view addSubview:_datePickerContainer];
    }
    
    if ([self.activeTextField isEqual:self.endDateTextField]) {
        _datePicker.minimumDate = self.startDate;
    } else {
        _datePicker.minimumDate = nil;
    }
    
    return _datePickerContainer;
}

- (void)datePickerDidChangeValue:(UIDatePicker *)sender {
    NSDate *selectedDate = sender.date;
    NSString *formattedDate = [self.dateFormatter stringFromDate:selectedDate];
    self.activeTextField.text = formattedDate;
    
    if ([self.activeTextField isEqual:self.startDateTextField]) {
        self.startDate = selectedDate;
    } else if ([self.activeTextField isEqual:self.endDateTextField]) {
        self.endDate = selectedDate;
    }
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    NSLog(@"Device orientation did change.");
}

- (void)displayDatePickerContainer:(NSNotification *)notification {
    CGRect newFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    [self displayDatePickerContainerWithFrame:newFrame];
}

- (void)displayDatePickerContainerWithFrame:(CGRect)frame {
    UIView *picker = self.datePickerContainer;
    
    [UIView animateWithDuration:0.25 animations:^{
        picker.frame = frame;
    }];
}

- (void)dismissDatePickerContainer:(UIView *)picker {
    [UIView animateWithDuration:0.25 animations:^{
        self.datePickerContainer.frame = CGRectMake(0,
                                                    CGRectGetMaxY(self.view.frame),
                                                    self.view.frame.size.width,
                                                    self.view.frame.size.height / 3.0);
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.quantityTypeIdentifiers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HealthIdentifierCell];
    
    NSString *key = self.quantityNames[indexPath.row];
    cell.textLabel.text = key;
    
    HKQuantityTypeIdentifier ident = [self.quantityTypeIdentifiers objectForKey:key];
    if ([self.selectedHealthTypes containsObject:ident]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *key = cell.textLabel.text;
    HKQuantityTypeIdentifier ident = [self.quantityTypeIdentifiers objectForKey:key];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [self.selectedHealthTypes removeObject:ident];
    } else if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        [self.selectedHealthTypes addObject:ident];
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.graphTitleTextField]) {
        return YES;
    } else {
        self.activeTextField = textField;
        
        if (self.graphTitleTextField.isFirstResponder) {
            [self.graphTitleTextField resignFirstResponder];
        }
        
        CGFloat yOffset = CGRectGetMaxY(self.view.frame) - self.datePickerContainer.frame.size.height;
        CGRect newFrame = CGRectMake(0,
                                     yOffset,
                                     self.datePickerContainer.frame.size.width,
                                     self.datePickerContainer.frame.size.height);
        
        [self displayDatePickerContainerWithFrame:newFrame];
        
        return NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.activeTextField = self.startDateTextField;
    
    return YES;
}

@end
