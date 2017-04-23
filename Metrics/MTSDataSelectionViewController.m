//
//  MTSDataSelectionViewController.m
//  Metrics
//
//  Created by Daniel Strokis on 4/23/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSDataSelectionViewController.h"
#import "MTSGraphCreationViewController.h"


static NSString * const HealthIdentifierCell = @"HealthIdentifierCell";

@interface MTSDataSelectionViewController ()

@property (strong, nonatomic) NSMutableSet <HKQuantityTypeIdentifier>*selectedHealthTypes;
@property NSArray <NSDictionary <HKQuantityTypeIdentifier, NSString *> *> *healthCategories;
@property (nonatomic) NSArray <NSString *>*healthTypeIconNames;

@end

@implementation MTSDataSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSelectedHealthTypes:[NSMutableSet set]];
    [self setHealthCategories:MTSQuantityTypeHealthCategories()];
    [self setHealthTypeIconNames:@[
                                   @"body-measurements",
                                   @"fitness",
                                   @"vitals",
                                   @"results",
                                   @"nutrition"
                                   ]];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self healthCategories] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = [[self healthTypeIconNames] objectAtIndex:section];
    
    title = [title stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    title = [title localizedCapitalizedString];
    
    return title;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *category = [[self healthCategories] objectAtIndex:section];
    return [category count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HealthIdentifierCell];
    
    NSDictionary <HKQuantityTypeIdentifier, NSString *> *category = [[self healthCategories] objectAtIndex:[indexPath section]];
    NSArray *keys = [category allKeys];
    
    HKQuantityTypeIdentifier key = [keys objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[category valueForKey:key]];
    
    NSString *iconName = [[self healthTypeIconNames] objectAtIndex:[indexPath section]];
    UIImage *icon = [UIImage imageNamed:iconName];
    [[cell imageView] setImage:icon];
    
    if ([[self selectedHealthTypes] containsObject:key]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary <HKQuantityTypeIdentifier, NSString *> *category = [[self healthCategories] objectAtIndex:[indexPath section]];
    HKQuantityTypeIdentifier ident = [[category allKeys] objectAtIndex:[indexPath row]];
    
    if ([[self selectedHealthTypes] containsObject:ident]) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [[self selectedHealthTypes] removeObject:ident];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [[self selectedHealthTypes] addObject:ident];
    }
}

#pragma mark - Navigation

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"createGraph"]) {
        MTSGraphCreationViewController *controller = (MTSGraphCreationViewController *)[segue destinationViewController];
        [controller setQuery:[self query]];
    }
}

@end
