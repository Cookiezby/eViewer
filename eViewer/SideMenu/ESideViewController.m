//
//  ESideMenuViewController.m
//  eViewer
//
//  Created by cookie on 6/14/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "ESideViewController.h"
#import "EPresentationAnimator.h"
#import "EPresentationController.h"
#import "Masonry.h"
#import <BlocksKit+UIKit.h>
typedef void (^ButtonEventHandler)();

@interface ESideViewController ()

@property (strong, nonatomic) UIButton *closeMenuButton;
@property (strong, nonatomic) UIButton *aboutButton;

@end

@implementation ESideViewController

- (instancetype)init{
    self = [super init];
    if(self){
        self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, SCREEN_HEIGHT)];
        self.view.backgroundColor = [UIColor whiteColor];
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closeMenu)];
        swipe.direction = UISwipeGestureRecognizerDirectionLeft;
        swipe.numberOfTouchesRequired = 1;
        [self.view addGestureRecognizer:swipe];
        
        [self customViewInit];
    }
    return self;
}

- (void)customViewInit{
    _closeMenuButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(closeMenu) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"Close" forState:UIControlStateNormal];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(@-100);
            make.width.equalTo(@100);
            make.height.equalTo(@50);
        }];
        button;
    });
    
    _aboutButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(@200);
            make.width.equalTo(@100);
            make.height.equalTo(@50);
        }];
        button.backgroundColor = [UIColor darkGrayColor];
        [button setTitle:@"About" forState:UIControlStateNormal];
        [button bk_addEventHandler:^(id sender) {
            DebugLog(@"About");
            UIViewController *aboutController = [[UIViewController alloc]init];
           
        } forControlEvents:UIControlEventTouchUpInside];
        button;
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DebugLog(@"did load");
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)closeMenu{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIViewControllerTransitionDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    EPresentationController *presentationController = [[EPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    return presentationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    EPresentationAnimator *animator = [[EPresentationAnimator alloc]initWithBool:YES];
    return animator;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    EPresentationAnimator *animator = [[EPresentationAnimator alloc]initWithBool:NO];
    return animator;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
