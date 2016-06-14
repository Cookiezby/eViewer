//
//  EPresentationAnimator.m
//  eViewer
//
//  Created by cookie on 6/14/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "EPresentationAnimator.h"
#import "ESideMenuViewController.h"

@interface EPresentationAnimator()

@property (nonatomic) BOOL isPresenting;

@end

@implementation EPresentationAnimator

- (instancetype)initWithBool:(BOOL)isPresenting{
    self = [super init];
    if(self){
        self.isPresenting = isPresenting;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    if(_isPresenting){
        ESideMenuViewController *toVC = (ESideMenuViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        CGFloat viewWidth = toVC.view.frame.size.width;
        DebugLog(@"%f",viewWidth);
        CGRect initialFrame = CGRectMake(0, 0, viewWidth, SCREEN_HEIGHT);
        CGRect startFrame = CGRectOffset(initialFrame, -viewWidth, 0);
        [[transitionContext containerView]addSubview:toVC.view];
        toVC.view.frame = startFrame;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            toVC.view.frame = initialFrame;
        } completion:^(BOOL finished) {
            //DebugLog(@"animation finished");
            [transitionContext completeTransition:YES];
        }];
    }else{
        UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        //CGRect finalFrame = [transitionContext finalFrameForViewController:fromViewController];
        
        CGRect finalFrame = fromViewController.view.frame;
        finalFrame.origin.x -= finalFrame.size.width;
        
        
        //finalFrame.origin.y = 1.2*CGRectGetHeight([transitionContext containerView].frame);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.frame = finalFrame;
        }completion:^(BOOL finished) {
            //DebugLog(@"dismiss");
            [transitionContext completeTransition:YES];
        }];

    }
}


@end
