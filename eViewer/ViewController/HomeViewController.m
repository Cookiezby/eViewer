//
//  HomeViewController.m
//  eViewer
//
//  Created by cookie on 6/14/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "HomeViewController.h"
#import "ESideMenuViewController.h"
#import "EVHTMLManager.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "ArticleSimple.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HomePageTableViewCell.h"

@interface HomeViewController () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *articleLists;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *leftMenuButton = [[UIBarButtonItem alloc]initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(showSlideMenu)];
    self.navigationItem.leftBarButtonItem =leftMenuButton;
    self.navigationItem.title = @"Engadget";
    
    self.articleLists = [[NSMutableArray alloc]init];
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        [self.view addSubview:tableView];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[HomePageTableViewCell class] forCellReuseIdentifier:@"HomePageCell"];
        [tableView setBackgroundColor:[UIColor colorWithHexString:@"ECECEC"]];
        tableView;
    });
    
    EVHTMLManager *manager = [[EVHTMLManager alloc]init];
    
    [SVProgressHUD show];
    
    [manager getPage:2 withHandler:^(NSMutableArray *array) {
        [self.articleLists addObjectsFromArray:array];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showSlideMenu{
    ESideMenuViewController *sideMenu = [[ESideMenuViewController alloc]init];
    [self presentViewController:sideMenu animated:YES completion:nil];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.articleLists.count;
    //return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    //return self.articleLists.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    HomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageCell"];
    
    ArticleSimple *articleSimple = self.articleLists[indexPath.section];
    
    
    cell.titleLabel.text = articleSimple.title;
    [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:articleSimple.coverImageURL]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    
    return cell;
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
