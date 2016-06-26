//
//  ESideMenuViewController.m
//  eViewer
//
//  Created by cookie on 6/26/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "EVSideViewController.h"
#import "DemoNaviViewController.h"
#import "DemoMenuViewController.h"
#import "DemoHomeViewController.h"

@interface EVSideViewController ()

@property (strong, nonatomic) UIViewController *contentViewController;
@property (strong, nonatomic) DemoMenuViewController *menuViewController;

@end

@implementation EVSideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DemoHomeViewController *homeViewController = [[DemoHomeViewController alloc]init];
    DemoNaviViewController *naviViewController = [[DemoNaviViewController alloc]initWithRootViewController:homeViewController];
    
    [self addChildViewController:naviViewController];
    [self.view addSubview:naviViewController.view];
    naviViewController.view.frame = self.view.frame;
    [naviViewController didMoveToParentViewController:self];
    
    self.menuViewController = [[DemoMenuViewController alloc]init];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMenu{
    DebugLog(@"EEE");
    [self addChildViewController:self.menuViewController];
    [self.view addSubview:self.menuViewController.view];
    self.menuViewController.view.frame = self.view.frame;
    [self.menuViewController didMoveToParentViewController:self];
    
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
