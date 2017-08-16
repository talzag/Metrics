//
//  MTSSamplesPresentationController.m
//  Metrics
//
//  Created by Daniel Strokis on 8/16/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSSamplesPresentationController.h"

@interface MTSSamplesPresentationController () // <UIViewControllerAnimatedTransitioning>

@end

@implementation MTSSamplesPresentationController 

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if (self) {
        [presentedViewController setModalPresentationStyle:UIModalPresentationCustom];
    }
    
    return self;
}

- (void)presentationTransitionWillBegin {
    
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    
}

@end
