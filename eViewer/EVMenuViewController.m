//
//  DemoMenuViewController.m
//  eViewer
//
//  Created by cookie on 6/26/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "EVMenuViewController.h"
#import "Masonry.h"
#import "EVSideViewController.h"

const static CGFloat MENU_ANIMATION_LENGTH = 0.3f;

@interface EVMenuViewController () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UIView *backGroundView;
@property (strong, nonatomic) UIView *menuView;
@property (strong, nonatomic) NSMutableArray *viewControllerList;
@property (strong, nonatomic) UIVisualEffectView *backGroundBlurView;

@end

@implementation EVMenuViewController

- (instancetype)initWithViewControllerList:(NSMutableArray *)viewControllerList{
    self = [super init];
    if (self) {
        _viewControllerList = viewControllerList;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /*self.backGroundBlurView = ({
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *bluredView = [[UIVisualEffectView alloc] initWithEffect:effect];
        
        bluredView.frame = self.view.bounds;
        [self.view addSubview:bluredView];
        bluredView;
    });*/
    
    self.backGroundView = ({
        UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideMenu)];
        [view addGestureRecognizer:tap];
        [self.view addSubview:view];
        view;
    });
    
    self.menuView = ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@-250);
            make.width.equalTo(@250);
            make.height.equalTo(@(SCREEN_HEIGHT));
        }];
        
        
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        [view addSubview:tableView];
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.top.equalTo(@100);
        }];
        
        view;
    });
    [self.view layoutIfNeeded];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self showMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - HideShowMenuAniamtion

- (void)showMenu{
    EVSideViewController *parentViewController = (EVSideViewController *)self.parentViewController;
    
    [self.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(@250);
        make.height.equalTo(@(SCREEN_HEIGHT));
    }];
    
    [UIView animateWithDuration:MENU_ANIMATION_LENGTH animations:^{
        [self.view layoutIfNeeded];
        self.backGroundView.alpha = 0.5f;
        parentViewController.contentViewController.view.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        DebugLog(@"menu appear");
    }];
    
    
}

- (void)hideMenu{
    DebugLog(@"hideMenu");
    EVSideViewController *parentViewController = (EVSideViewController *)self.parentViewController;
    
    [self.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@-250);
        make.width.equalTo(@250);
        make.height.equalTo(@(SCREEN_HEIGHT));
    }];
    
    [UIView animateWithDuration:MENU_ANIMATION_LENGTH animations:^{
        self.backGroundView.alpha = 0.0;
        [self.view layoutIfNeeded];
        parentViewController.contentViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [parentViewController hideMenu];
    }];
}

#pragma mark - UITableViewDelagate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EVSideViewController *parentViewController = (EVSideViewController *)self.parentViewController;
    [parentViewController changeToViewControllerAtIndex:indexPath.row];
    [self hideMenu];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
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
