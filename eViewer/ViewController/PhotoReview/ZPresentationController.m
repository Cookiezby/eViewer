//
//  ZPresentationController.m
//  eViewer
//
//  Created by cookie on 7/17/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "ZPresentationController.h"

@interface ZPresentationController()

@property (strong,nonatomic) UIView *backGroundView;

@end

@implementation ZPresentationController


- (void)presentationTransitionWillBegin{
    
    
    
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        //设置Presentaion时候的动画
    } completion:nil];
}


- (void)presentationTransitionDidEnd:(BOOL)completed{
    
}


- (void)dismissalTransitionWillBegin{
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
       //设置Dismiss时候的动画
    } completion:nil];
}


- (void)dismissalTransitionDidEnd:(BOOL)completed{
    
}


@end
