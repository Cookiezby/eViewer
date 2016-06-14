//
//  EPresentationController.m
//  eViewer
//
//  Created by cookie on 6/14/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "EPresentationController.h"
#import "Masonry.h"

@interface EPresentationController()

@property (strong, nonatomic)UIView* backGroundView;

@end

@implementation EPresentationController

- (void)presentationTransitionWillBegin{
    //DebugLog(@"presentation start");
    self.backGroundView = [[UIView alloc]initWithFrame:CGRectZero];
    self.backGroundView.backgroundColor = [UIColor blackColor];
    self.backGroundView.alpha = 0.0;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognized:)];
    [self.backGroundView addGestureRecognizer:tap];
    [self.containerView addSubview:_backGroundView];
    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    
    //背景黑色渐变
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.backGroundView.alpha = 0.5f;
    } completion:nil];

}

- (void)presentationTransitionDidEnd:(BOOL)completed{
    //DebugLog(@"presentation end");
    if(!completed){
        [self.backGroundView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin{
    //背景黑色渐变
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.backGroundView.alpha = 0.0f;
    } completion:nil];
}


- (void)dismissalTransitionDidEnd:(BOOL)completed{
    if(completed){
        [self.backGroundView removeFromSuperview];
    }
}

- (BOOL)shouldRemovePresentersView{
    return NO;
}

- (BOOL)shouldPresentInFullscreen{
    return NO; //表示present的view只占了VC的一部分
}

- (void)tapGestureRecognized:(UITapGestureRecognizer *)gesture{
    //DebugLog(@"click back");
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
