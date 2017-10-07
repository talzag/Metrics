//
//  MTSGraphViewController.m
//  Metrics
//
//  Created by Daniel Strokis on 2/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphViewController.h"
#import "MTSColorPickerTableViewCell.h"
#import "MTSSamplesTableViewController.h"
#import "MTSSamplesPresentationController.h"

@interface MTSGraphViewController ()

@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) NSArray *graphQueries;
@property (nonatomic) NSDictionary <HKQuantityTypeIdentifier, NSString *> *healthTypeNameLookup;

@end

@implementation MTSGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationItem] setTitle:[[self graph] title]];
    [[self startDateLabel] setText:[[self dateFormatter] stringFromDate:[[self graph] startDate]]];
    [[self endDateLabel] setText:[[self dateFormatter] stringFromDate:[[self graph] endDate]]];
    [self setGraphQueries:[[[self graph] queries] allObjects]];
    [self setHealthTypeNameLookup:MTSQuantityTypeIdentifiers()];
    
    MTSGraph *graph = [self graph];
    [[self graphView] setGraph:graph];
    [graph executeQueriesWithHealthStore:[self healthStore] usingCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self graphView] setNeedsDisplay];
            });
        }
    }];
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"MMM dd, yyyy"];
        [_dateFormatter setLocale:[NSLocale currentLocale]];
    }
    return _dateFormatter;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [[self graphView] setNeedsDisplayInRect:CGRectMake(0, 0, size.width, size.width)];
}

// MARK: - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self graphQueries] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MTSColorPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"healthDataCell" forIndexPath:indexPath];
    
    MTSQuery *query = [[self graphQueries] objectAtIndex:[indexPath row]];
    NSString *value = [[self healthTypeNameLookup] objectForKey:[query healthKitTypeIdentifier]];
    
    [[cell textLabel] setText:value];
    
    [[cell colorSwatchView] setBackgroundColor:[query lineColor]];
    [cell setColorSelectionEnabled:NO];
    
    return cell;
}

// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MTSSamplesTableViewController *samplesTableViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SamplesTableViewController"];
    
    // set samples for the controller
    MTSSamplesPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
    presentationController = [[MTSSamplesPresentationController alloc] initWithPresentedViewController:samplesTableViewController presentingViewController:self];
    
    samplesTableViewController.transitioningDelegate = presentationController;
    
    MTSQuery *query = [[self graphQueries] objectAtIndex:[indexPath row]];
    NSArray *samples = [query fetchedDataPoints];
    [samplesTableViewController setSamples:samples];
    
    [self presentViewController:samplesTableViewController animated:YES completion:nil];
}

@end
