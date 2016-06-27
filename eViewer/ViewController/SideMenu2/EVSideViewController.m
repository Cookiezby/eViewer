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

@property (strong, nonatomic) NSMutableArray *contentViewControllerList;

@end

@implementation EVSideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DemoHomeViewController *homeViewController = [[DemoHomeViewController alloc]init];
    DemoNaviViewController *naviViewController = [[DemoNaviViewController alloc]initWithRootViewController:homeViewController];
    
    self.contentViewController = naviViewController;
    
    
    self.menuViewController = [[DemoMenuViewController alloc]init];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMenu{
    DebugLog(@"%ld",self.view.subviews.count);
    [self addChildController:self.menuViewController toParentViewController:self atIndex:self.view.subviews.count];
    //index越大表示越在前面，最里面的view的index为0，所以如果要插入到最前面的话就需要插入到 subviews.count位置
}

- (void)hideMenu{
    [self removeChildController:self.menuViewController];
}

- (void)changeToSecondViewController{
    
    DemoSecondViewController *secondViewController = [[DemoSecondViewController alloc]init];
    DemoNaviViewController *navi = [[DemoNaviViewController alloc]initWithRootViewController:secondViewController];
    
    self.contentViewController = navi;
}

- (void)changeToFirstViewController{
    
    DemoHomeViewController *firstViewController = [[DemoHomeViewController alloc]init];
    DemoNaviViewController *navi = [[DemoNaviViewController alloc]initWithRootViewController:firstViewController];
    
    self.contentViewController = navi;
}


- (void)changeToViewControllerAtIndex:(NSInteger)index{
    UIViewController *viewController = self.contentViewControllerList[index];
    DemoNaviViewController *navigationController = [[DemoNaviViewController alloc]initWithRootViewController:viewController];
    self.contentViewController = navigationController;
}

- (void)setContentViewController:(DemoNaviViewController *)contentViewController{
    if(_contentViewController){
        [self removeChildController:_contentViewController];
    }
    [self addChildController:contentViewController toParentViewController:self atIndex:0];
    _contentViewController = contentViewController;
}


#pragma mark - ContainerViewControllerHelper

- (void)addChildController:(UIViewController *)child toParentViewController:(UIViewController *)parent atIndex:(NSInteger) index{
    [parent addChildViewController:child];
    //切换contentViewController的时候保证在menuViewController的下面
    [parent.view insertSubview:child.view atIndex:index];
    child.view.frame = parent.view.frame;
    [child didMoveToParentViewController:parent];
}

- (void)removeChildController:(UIViewController *)child{
    [child willMoveToParentViewController:nil];
    [child.view removeFromSuperview];
    [child removeFromParentViewController];
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
