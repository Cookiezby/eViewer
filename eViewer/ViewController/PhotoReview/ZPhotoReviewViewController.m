//
//  ZPhotoReviewViewController.m
//  eViewer
//
//  Created by cookie on 7/17/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "ZPhotoReviewViewController.h"
#import "Masonry.h"
#import "ZPresentationController.h"
#import "ZPresentationAnimator.h"

@interface ZPhotoReviewViewController ()

@property (strong, nonatomic)UIView *test;

@end

@implementation ZPhotoReviewViewController

- (instancetype)init{
    self = [super init];
    if(self){
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.test = ({
        UIView *view = [[UIView alloc]init];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.equalTo(@100);
            make.height.equalTo(@100);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(dismiss)];
        [self.view addGestureRecognizer:tap];
        
        view.backgroundColor = [UIColor blackColor];
        view;
    });
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismiss{
    DebugLog(@"dismiss");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitionDeletgate
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    ZPresentationController *presentationController = [[ZPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    return presentationController;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    ZPresentationAnimator *animator = [[ZPresentationAnimator alloc]initWithBool:NO];
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    ZPresentationAnimator *animator = [[ZPresentationAnimator alloc]initWithBool:YES];
    return animator;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    return nil;
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
