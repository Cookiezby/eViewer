//
//  DemoNaviViewController.m
//  eViewer
//
//  Created by cookie on 6/26/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "EVNaviViewController.h"
#import "EVSideViewController.h"

@interface EVNaviViewController ()

@end

@implementation EVNaviViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if(self){
        self.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationBar.translucent = NO;
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"1EA2E0"]}];
        self.navigationBar.tintColor = [UIColor colorWithHexString:@"1EA2E0"];
        self.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"BarBackButton.png"];
        self.navigationBar.backIndicatorImage = [UIImage imageNamed:@"BarBackButton.png"];
        /*self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        UIBarButtonItem *leftBarbuttonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"MenuButton.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
        self.navigationItem.leftBarButtonItem = leftBarbuttonItem;
        self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"EggIcon.png"]];*/
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMenu{
    DebugLog(@"???");
    EVSideViewController *sideViewController = (EVSideViewController *)self.parentViewController;
    [sideViewController showMenu];
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
