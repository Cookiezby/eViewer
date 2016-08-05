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
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"EggIcon.png"]];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView;
    });
    

    // Do any additional setup after loading the view.
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
    UITableViewCell *cell = [[UITableViewCell alloc]init];
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
