//
//  MTSDataSelectionViewController.m
//  Metrics
//
//  Created by Daniel Strokis on 4/23/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSDataSelectionViewController.h"
#import "MTSGraphCreationViewController.h"

@interface MTSDataSelectionViewController ()

@property (strong, nonatomic) NSMutableSet <HKQuantityTypeIdentifier>*selectedHealthTypes;
@property NSArray <NSDictionary <HKQuantityTypeIdentifier, NSString *> *> *healthCategories;
@property (nonatomic) NSArray <NSString *>*healthTypeIconNames;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *category = [[self healthCategories] objectAtIndex:section];
    return [category count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"healthIdentifierCell"];
    
    NSDictionary <HKQuantityTypeIdentifier, NSString *> *category = [[self healthCategories] objectAtIndex:[indexPath section]];
    NSArray *keys = [category allKeys];
    
    HKQuantityTypeIdentifier key = [keys objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[category valueForKey:key]];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = 30;
    
    NSString *title = [[self healthTypeIconNames] objectAtIndex:section];
    UIImage *image = [UIImage imageNamed:title];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake(0, 0, 30, 30)];
    [[[imageView widthAnchor] constraintEqualToConstant:[imageView frame].size.height] setActive:YES];
    
    title = [title stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    title = [title localizedCapitalizedString];
    
    CGFloat width = [tableView frame].size.width;
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesFontLeading attributes:nil context:nil];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleRect];
    [titleLabel setText:title];
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[imageView, titleLabel]];
    [stackView setFrame:CGRectMake(0, 0, width, height)];
    [stackView setAxis:UILayoutConstraintAxisHorizontal];
    [stackView setSpacing:8.0];
    [stackView setDistribution:UIStackViewDistributionFillProportionally];
    [stackView setAlignment:UIStackViewAlignmentCenter];
    
    UIView *view = [[UIView alloc] initWithFrame:[stackView frame]];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:stackView];
    [view setLayoutMargins:UIEdgeInsetsMake(20, 20, 20, 20)];
    
    return view;
}

#pragma mark - Navigation

- (IBAction)cancel:(id)sender {
    NSManagedObjectContext *context = [[self graph] managedObjectContext];
    [context deleteObject:[self graph]];
    
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"createGraph"]) {
        NSMutableSet *configs = [NSMutableSet set];
        
        NSDictionary <HKQuantityTypeIdentifier, NSString *> *identifiers = MTSQuantityTypeIdentifiers();
        for (HKQuantityTypeIdentifier type in [self selectedHealthTypes]) {
            NSString *displayName = [identifiers valueForKey:type];
            MTSQueryDataConfiguration *config = [[MTSQueryDataConfiguration alloc] initWithContext:[[self graph] managedObjectContext]];
            [config setHealthTypeDisplayName:displayName];
            [config setHealthKitTypeIdentifier:type];
            [configs addObject:config];
            
        }
        [[[self graph] query] setDataTypeConfigurations:[NSSet setWithSet:configs]];
        
        MTSGraphCreationViewController *controller = (MTSGraphCreationViewController *)[segue destinationViewController];
        [controller setGraph:[self graph]];
    }
}

@end
