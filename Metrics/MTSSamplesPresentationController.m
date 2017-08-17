//
//  MTSSamplesPresentationController.m
//  Metrics
//
//  Created by Daniel Strokis on 8/16/17.
//  Copyright © 2017 dstrokis. All rights reserved.
//

#import "MTSSamplesPresentationController.h"

@interface MTSSamplesPresentationController () <UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIView *presentationWrappingView;

@end

@implementation MTSSamplesPresentationController 

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if (self) {
        [presentedViewController setModalPresentationStyle:UIModalPresentationCustom];
    }
    
    return self;
}

- (UIView *)presentedView {
    return [self presentationWrappingView];
}

- (void)presentationTransitionWillBegin {
    
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [self setPresentationWrappingView:nil];
        [self setDimmingView:nil];
    }
}

- (void)dismissalTransitionWillBegin {
    
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [self setPresentationWrappingView:nil];
        [self setDimmingView:nil];
    }
}

# pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return [transitionContext isAnimated] ? 0.35 : 0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
}

# pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

@end
