//
//  MTSGraphViewController.m
//  Metrics
//
//  Created by Daniel Strokis on 2/13/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSGraphViewController.h"

@interface MTSGraphViewController ()
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

@end

@implementation MTSGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.graph.title;
    // TODO: Use NSDateFormatter here
    self.startDateLabel.text = self.graph.startDate.description;
    self.endDateLabel.text = self.graph.endDate.description;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
