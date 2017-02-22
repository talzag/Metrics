//
//  MTSGraphCreationViewController.m
//  Metrics
//
//  Created by Daniel Strokis on 2/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphCreationViewController.h"
@import HealthKit;

static NSString * const HealthIdentifierCell = @"HealthIdentifierCell";

@interface MTSGraphCreationViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray <NSString *>*quantityNames;
@property (strong, nonatomic) NSMutableSet <HKQuantityTypeIdentifier>*selectedHealthTypes;

@end

@implementation MTSGraphCreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.quantityNames = self.quantityTypeIdentifiers.allKeys;
    self.selectedHealthTypes = [NSMutableSet set];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSSet *)selectedHealthMetrics {
    return [NSSet setWithSet:self.selectedHealthTypes];
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
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
    return [textField isEqual:self.graphTitleTextField];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

@end
