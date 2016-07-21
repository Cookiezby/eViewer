//
//  ZPresentationAnimator.m
//  eViewer
//
//  Created by cookie on 7/17/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "ZPresentationAnimator.h"
#import "ZPhotoReviewViewController.h"

@interface ZPresentationAnimator()

@property (nonatomic) BOOL isPresentaion;

@end

@implementation ZPresentationAnimator

- (instancetype)initWithBool:(BOOL)isPresentation{
    self = [super init];
    if(self){
        _isPresentaion = isPresentation;
    }
    return self;
}


#pragma mark - UIViewControllerAnimatedTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    if(!_isPresentaion){
        ZPhotoReviewViewController *toVC = (ZPhotoReviewViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        CGRect startFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        toVC.view.frame = startFrame;
        toVC.view.alpha = 0.0;
        
        [[transitionContext containerView]addSubview:toVC.view];
        
        [UIView animateWithDuration:0.3f animations:^{
            toVC.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else{
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        //CGRect finalFrame = [transitionContext finalFrameForViewController:fromVC];
        
        CGRect startFrame = fromVC.view.frame;
        //CGRect endFrame = CGRectMake(0, startFrame.origin.y - SCREEN_HEIGHT, startFrame.size.width, startFrame.size.height);
        
        [UIView animateWithDuration:0.3f animations:^{
            fromVC.view.alpha = 0.0;
            //fromVC.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        

    }
    
    
}


@end
