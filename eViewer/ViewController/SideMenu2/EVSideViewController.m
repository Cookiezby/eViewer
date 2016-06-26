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
#import "DemoSecondViewController.h"

@interface EVSideViewController ()

@property (strong, nonatomic) DemoNaviViewController *contentViewController;
@property (strong, nonatomic) DemoMenuViewController *menuViewController;

@end

@implementation EVSideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DemoHomeViewController *homeViewController = [[DemoHomeViewController alloc]init];
    DemoNaviViewController *naviViewController = [[DemoNaviViewController alloc]initWithRootViewController:homeViewController];
    
    self.contentViewController = naviViewController;
    
    [self addChildViewController:self.contentViewController];
    [self.view addSubview:self.contentViewController.view];
    self.contentViewController.view.frame = self.view.frame;
    [self.contentViewController didMoveToParentViewController:self];
    
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

- (void)hideMenu{
    [self.menuViewController willMoveToParentViewController:nil];
    [self.menuViewController.view removeFromSuperview];
    [self.menuViewController removeFromParentViewController];
}

- (void)changeToSecondViewController{
    [self.contentViewController willMoveToParentViewController:nil];
    [self.contentViewController.view removeFromSuperview];
    [self.contentViewController removeFromParentViewController];
    
    DemoSecondViewController *secondViewController = [[DemoSecondViewController alloc]init];
    DemoNaviViewController *navi = [[DemoNaviViewController alloc]initWithRootViewController:secondViewController];
    
    self.contentViewController = navi;
    [self addChildViewController:self.contentViewController];
    [self.view insertSubview:self.contentViewController.view atIndex:0];
    self.contentViewController.view.frame = self.view.frame;
    [self.contentViewController didMoveToParentViewController:self];
}

- (void)changeToFirstViewController{
    [self.contentViewController willMoveToParentViewController:nil];
    [self.contentViewController.view removeFromSuperview];
    [self.contentViewController removeFromParentViewController];
    
    DemoHomeViewController *firstViewController = [[DemoHomeViewController alloc]init];
    DemoNaviViewController *navi = [[DemoNaviViewController alloc]initWithRootViewController:firstViewController];
    
    self.contentViewController = navi;
    [self addChildViewController:self.contentViewController];
    [self.view insertSubview:self.contentViewController.view atIndex:0];
    self.contentViewController.view.frame = self.view.frame;
    [self.contentViewController didMoveToParentViewController:self];
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
