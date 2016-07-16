//
//  HomeViewController.m
//  eViewer
//
//  Created by cookie on 6/14/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "HomeViewController.h"
#import "EVSideViewController.h"
#import "EVHTMLManager.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "ArticleSimple.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HomePageTableViewCell.h"

@interface HomeViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

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
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]bk_initWithTitle:@"Menu"
                                                                               style:UIBarButtonItemStylePlain
                                                                             handler:^(id sender) {
                                                                                 DebugLog(@"showMenu");
                                                                                 EVNaviViewController *naviViewController = (EVNaviViewController *)self.navigationController;
                                                                                 [naviViewController showMenu];
                                                                            }];
    
    
    self.articleLists = [[NSMutableArray alloc]init];
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        [self.view addSubview:tableView];
        tableView.delegate = self;
        tableView.dataSource = self;
    
        [tableView registerClass:[HomePageTableViewCell class] forCellReuseIdentifier:@"HomePageCell"];
        [tableView setBackgroundColor:TABLE_VIEW_BACKGROUND_COLOR];
        tableView;
    });
    
    
    EVHTMLManager *manager = [[EVHTMLManager alloc]init];
    
    [SVProgressHUD show];
    
    [manager getPage:1 withHandler:^(NSMutableArray *array) {
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
    EVSideViewController *sideMenu = [[EVSideViewController alloc]init];
    [self presentViewController:sideMenu animated:YES completion:nil];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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
    
    cell.authorLabel.text = articleSimple.author;
    cell.titleLabel.text = articleSimple.title;
    cell.postTimeLabel.text = articleSimple.postTime;
    [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:articleSimple.coverImageURL]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    
    
    
    return cell;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y < -150.0f){
        [UIView animateWithDuration:0.5f animations:^{
            self.tableView.contentInset = UIEdgeInsetsMake(120.0f, 0.0f, 0.0f, 0.0f);
        } completion:^(BOOL finished) {
            //在这里添加refresh的动画
            
            
            
            EVHTMLManager *manager = [[EVHTMLManager alloc]init];
            [self.articleLists removeAllObjects];
            [manager getPage:1 withHandler:^(NSMutableArray *array) {
                [self.articleLists addObjectsFromArray:array];
                [self.tableView reloadData];
                [UIView animateWithDuration:0.5f animations:^{
                    self.tableView.contentInset = UIEdgeInsetsMake(64.0f, 0.0f, 0.0f, 0.0f);
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if((scrollView.contentOffset.y + scrollView.frame.size.height - 20) >= scrollView.contentSize.height){
        [UIView animateWithDuration:0.5f animations:^{
            //self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
        } completion:^(BOOL finished) {
            
        }];
    }
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
