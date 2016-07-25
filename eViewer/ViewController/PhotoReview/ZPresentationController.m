//
//  ZPresentationController.m
//  eViewer
//
//  Created by cookie on 7/17/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "ZPresentationController.h"
#import "ZPhotoReviewViewController.h"

@interface ZPresentationController()

@property (strong,nonatomic) UIView *backGroundView;

@end

@implementation ZPresentationController


- (void)presentationTransitionWillBegin{
    
    /*self.backGroundView = [[UIView alloc]initWithFrame:self.presentingViewController.view.frame];
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    self.backGroundView.alpha = 0.0;
    [self.containerView addSubview:self.backGroundView];
    [self.containerView addSubview:self.presentedView];
     */
    
    //ZPhotoReviewViewController *toVC = (ZPhotoReviewViewController *)self.presentedViewController;
    //[toVC.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:5 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        //设置Presentaion时候的动画
        //self.backGroundView.alpha = 1.0;
    } completion:nil];
}


- (void)presentationTransitionDidEnd:(BOOL)completed{
    
}


- (void)dismissalTransitionWillBegin{
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
       //设置Dismiss时候的动画
        //self.backGroundView.alpha = 0.0;
    } completion:nil];
}


- (void)dismissalTransitionDidEnd:(BOOL)completed{
    if(completed){
        //[self.backGroundView removeFromSuperview];
    }
}


@end
