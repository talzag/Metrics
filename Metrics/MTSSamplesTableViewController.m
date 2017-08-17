//
//  MTSSamplesTableViewController.m
//  Metrics
//
//  Created by Daniel Strokis on 8/16/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSSamplesTableViewController.h"

@interface MTSSamplesTableViewController ()

@end

@implementation MTSSamplesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self samples] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

@end
