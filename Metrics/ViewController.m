//
//  ViewController.m
//  Metrics
//
//  Created by Daniel Strokis on 2/4/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "ViewController.h"
#import "GraphView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *graphDataTypeOneLabel;
@property (weak, nonatomic) IBOutlet UITextField *graphDataTypeTwoLabel;
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

@property (strong) NSDate *startDate;
@property (strong) NSDate *endDate;
@property (strong) UIDatePicker *datePicker;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)displayDatePicker:(UITapGestureRecognizer *)sender {
    if ([self datePicker]) {
        return;
    }
    
    [self setDatePicker:[[UIDatePicker alloc] init]];
    UIDatePicker *picker = [self datePicker];
    [picker setDatePickerMode:UIDatePickerModeDate];
    [picker  addTarget:self action:@selector(datePickerDidChange:) forControlEvents:UIControlEventValueChanged];
    [picker  setFrame:CGRectMake(0,
                                CGRectGetMaxY(self.view.frame),
                                CGRectGetWidth(self.view.frame),
                                CGRectGetHeight([[self datePicker] frame]))];
    [[self view] addSubview:picker];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect pickerFrame = [picker frame];
        [picker setFrame:CGRectMake(0,
                                    CGRectGetHeight(self.view.frame) - CGRectGetHeight(pickerFrame),
                                    CGRectGetWidth(self.view.frame),
                                    CGRectGetHeight(pickerFrame))];
    }];
}


- (IBAction)datePickerDidChange:(id)sender {
    
}


- (void)queryHealthStore:(HKHealthStore * _Nonnull)healthStore
           forQuantityType:(HKQuantityTypeIdentifier _Nonnull)typeIdentifier
                fromDate:(NSDate * _Nonnull)startDate
                  toDate:(NSDate * _Nonnull)endDate
  usingCompletionHandler:(void (^)(NSArray <HKSample *>*samples)) completionHandler {
    NSPredicate *predicate = [HKSampleQuery predicateForSamplesWithStartDate:startDate
                                                                     endDate:endDate
                                                                     options:HKQueryOptionStrictEndDate];
    
    HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:typeIdentifier];
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:sampleType
                                                           predicate:predicate
                                                               limit:HKObjectQueryNoLimit
                                                     sortDescriptors:nil
                                                      resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
                                                          if (!results) {
                                                              NSLog(@"Error executing query: %@", error.localizedDescription);
                                                          }
        
    }];
    
    [self.healthStore executeQuery:query];
}

@end
