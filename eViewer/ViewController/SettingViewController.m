//
//  SettingViewController.m
//  eViewer
//
//  Created by cookie on 8/5/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "SettingViewController.h"
#import "EVNaviViewController.h"
#import "Masonry.h"
#import <SDImageCache.h>
#import "SettingMenuTableViewCell.h"
#import <MBProgressHUD.h>

@interface SettingViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)UITableView *tableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"1EA2E0"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]bk_initWithImage:[UIImage imageNamed:@"MenuButton.png"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        DebugLog(@"showMenu");
        EVNaviViewController *naviViewController = (EVNaviViewController *)self.navigationController;
        [naviViewController showMenu];
    }];
    //self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"EggIcon.png"]];
    self.navigationItem.title = @"设定";
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.backgroundColor = [UIColor colorWithHexString:@"EFF6F9"];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [tableView registerClass:[SettingMenuTableViewCell class] forCellReuseIdentifier:@"SettingCell"];
        tableView.scrollEnabled = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView;
    });
    

    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMenu{
    DebugLog(@"showMenu");
    EVNaviViewController *naviViewController = (EVNaviViewController *)self.navigationController;
    [naviViewController showMenu];
}


#pragma mark - UITbleViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:{
                [[SDImageCache sharedImageCache]clearDisk];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"清除成功", @"HUD message title");
                [hud hideAnimated:YES afterDelay:2.0f];
                [tableView reloadData];
            }
                
                break;
            case 1:
                break;
            default:
                break;
        }
    }else if(indexPath.section == 1){
        
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
    cell.titleLabel.textColor = [UIColor darkGrayColor];
    cell.titleLabel.font = [UIFont systemFontOfSize:14];
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:{
                cell.titleLabel.text = @"清空缓存";
                NSInteger cachedSize =[[SDImageCache sharedImageCache] getSize];
                cell.endLabel.text = [NSString stringWithFormat:@"%ld MB",cachedSize/1024/1024];
                //cell.iconView.image = [UIImage imageNamed:@"cache-icon.png"];
            }
                break;
            case 1:{
                cell.titleLabel.text = @"开源库许可";
                //cell.iconView.image = [UIImage imageNamed:@"licence-icon.png"];
            }
                
                break;
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:{
                cell.titleLabel.text = @"关于";
                //cell.iconView.image = [UIImage imageNamed:@"question-icon.png"];
            }
                
                break;
            case 1:
                
                break;
            }
    }
    
    
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
