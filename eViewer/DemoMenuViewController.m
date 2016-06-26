//
//  DemoMenuViewController.m
//  eViewer
//
//  Created by cookie on 6/26/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "DemoMenuViewController.h"
#import "Masonry.h"
#import "EVSideViewController.h"

@interface DemoMenuViewController ()

@property (strong, nonatomic) UIView *backGroundView;
@property (strong, nonatomic) UIView *menuView;


@end

@implementation DemoMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backGroundView = ({
        UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideMenu)];
        [view addGestureRecognizer:tap];
        [self.view addSubview:view];
        view;
    });
    
    self.menuView = ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@-250);
            make.width.equalTo(@250);
            make.height.equalTo(@(SCREEN_HEIGHT));
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Second" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor blueColor]];
        [button addTarget:self action:@selector(changeToSecondViewController) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
            make.width.equalTo(@100);
            make.height.equalTo(@50);
        }];
        
        
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button2 setTitle:@"First" forState:UIControlStateNormal];
        [button2 setBackgroundColor:[UIColor blueColor]];
        [button2 addTarget:self action:@selector(changeToFirstViewController) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button2];
        [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(button.mas_bottom).with.offset(100);
            make.width.equalTo(@100);
            make.height.equalTo(@50);
        }];
        
        
        view;
    });
    [self.view layoutIfNeeded];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(@250);
        make.height.equalTo(@(SCREEN_HEIGHT));
    }];

    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
        self.backGroundView.alpha = 0.5f;
    } completion:^(BOOL finished) {
        DebugLog(@"menu appear");
    }];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideMenu{
    DebugLog(@"hideMenu");
    EVSideViewController *parentViewController = (EVSideViewController *)self.parentViewController;
    
    [self.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@-250);
        make.width.equalTo(@250);
        make.height.equalTo(@(SCREEN_HEIGHT));
    }];
    
    
    [UIView animateWithDuration:0.5f animations:^{
        self.backGroundView.alpha = 0.0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [parentViewController hideMenu];
    }];
    
    
}

- (void)changeToSecondViewController{
    DebugLog(@"Change to Second");
    EVSideViewController *parentViewController = (EVSideViewController *)self.parentViewController;
    [parentViewController changeToSecondViewController];
    [self hideMenu];

}

- (void)changeToFirstViewController{
    DebugLog(@"Change to First");
    EVSideViewController *parentViewController = (EVSideViewController *)self.parentViewController;
    [parentViewController changeToFirstViewController];
    [self hideMenu];
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
