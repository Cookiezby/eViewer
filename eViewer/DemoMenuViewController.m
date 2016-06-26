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
