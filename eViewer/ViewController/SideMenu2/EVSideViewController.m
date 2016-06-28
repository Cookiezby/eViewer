//
//  ESideMenuViewController.m
//  eViewer
//
//  Created by cookie on 6/26/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "EVSideViewController.h"
#import "EVMenuViewController.h"
#import "DemoHomeViewController.h"
#import "DemoSecondViewController.h"

@interface EVSideViewController ()
@property (strong, nonatomic) EVMenuViewController *menuViewController;


@end

@implementation EVSideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    DebugLog(@"%ld",self.contentViewControllerList.count);
    
    //DemoHomeViewController *homeViewController = [[DemoHomeViewController alloc]init];
    EVNaviViewController *naviViewController = [[EVNaviViewController alloc]initWithRootViewController:_contentViewControllerList[0]];
    self.contentViewController = naviViewController;
    
    
    
    /*DemoSecondViewController *secondViewController = [[DemoSecondViewController alloc]init];
    self.contentViewControllerList = [[NSMutableArray alloc]initWithObjects:homeViewController,secondViewController, nil];*/
    self.menuViewController = [[EVMenuViewController alloc]init];
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMenu{
    //DebugLog(@"%ld",self.view.subviews.count);
    [self addChildController:self.menuViewController toParentViewController:self atIndex:self.view.subviews.count];
    //index越大表示越在前面，最里面的view的index为0，所以如果要插入到最前面的话就需要插入到 subviews.count位置
}

- (void)hideMenu{
    [self removeChildController:self.menuViewController];
}


- (void)changeToViewControllerAtIndex:(NSInteger)index{
    EVNaviViewController *navigationController = [[EVNaviViewController alloc]initWithRootViewController:_contentViewControllerList[index]];
    self.contentViewController = navigationController;
    self.contentViewController.view.transform = CGAffineTransformMakeScale(0.95, 0.95);
}

- (void)setContentViewController:(EVNaviViewController *)contentViewController{
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
