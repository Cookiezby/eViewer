//
//  HomeViewController.m
//  eViewer
//
//  Created by cookie on 6/14/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "HomeViewController.h"
#import "ESideMenuViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *leftMenuButton = [[UIBarButtonItem alloc]initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(showSlideMenu)];
    self.navigationItem.leftBarButtonItem =leftMenuButton;
    
    self.navigationController.title = @"Engadget";
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showSlideMenu{
    ESideMenuViewController *sideMenu = [[ESideMenuViewController alloc]init];
    [self presentViewController:sideMenu animated:YES completion:nil];
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
