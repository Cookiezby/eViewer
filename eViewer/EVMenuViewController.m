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
#import "MenuTableViewCell.h"

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
            make.left.equalTo(@(-SCREEN_WIDTH/3.0*2.0));
            make.width.equalTo(@(SCREEN_WIDTH/3.0*2.0));
            make.height.equalTo(@(SCREEN_HEIGHT));
        }];
        
        
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.scrollEnabled = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [view addSubview:tableView];
        [tableView registerClass:[MenuTableViewCell class] forCellReuseIdentifier:@"MenuCell"];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.top.equalTo(@200);
        }];
        
        
        UIView *topView = [[UIView alloc]init];
        topView.backgroundColor = [UIColor colorWithHexString:@"76C7ED"];
        [view addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@150);
        }];
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"engadget_logo.png"]];
        [topView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(topView);
        }];
        
        
        
        UILabel *versionLabel = [[UILabel alloc]init];
        versionLabel.textColor = [UIColor whiteColor];
        versionLabel.text = @"V1.0";
        versionLabel.font = [UIFont boldSystemFontOfSize:13];
        [versionLabel sizeToFit];
        [topView addSubview:versionLabel];
        [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-5);
            make.bottom.equalTo(@-5);
        }];
        
        view;
    });
    [self.view layoutIfNeeded];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
   
    [self showMenu];
}

- (void)viewWillDisappear:(BOOL)animated{
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - HideShowMenuAniamtion

- (void)showMenu{
    EVSideViewController *parentViewController = (EVSideViewController *)self.parentViewController;
    //parentViewController.contentViewController.navigationBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    CGRect preFrame = parentViewController.contentViewController.view.frame;
    [self.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH/3.0*2.0));
        make.height.equalTo(@(SCREEN_HEIGHT));
    }];
    
    [UIView animateWithDuration:MENU_ANIMATION_LENGTH delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view layoutIfNeeded];
        self.backGroundView.alpha = 0.5f;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        parentViewController.contentViewController.view.frame = CGRectMake(0, 20, preFrame.size.width, preFrame.size.height);
    
    } completion:^(BOOL finished) {
        
    }];
   
    
}

- (void)hideMenu{
    EVSideViewController *parentViewController = (EVSideViewController *)self.parentViewController;
    [self.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@(-SCREEN_WIDTH/3.0*2.0));
        make.width.equalTo(@(SCREEN_WIDTH/3.0*2.0));
        make.height.equalTo(@(SCREEN_HEIGHT));
    }];
    
    
    [UIView animateWithDuration:MENU_ANIMATION_LENGTH animations:^{
        self.backGroundView.alpha = 0.0;
        [self.view layoutIfNeeded];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        //parentViewController.contentViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    switch (indexPath.row) {
        case 0:
            cell.iconView.image = [UIImage imageNamed:@"HomeIcon.png"];
            cell.titleLabel.text = @"首页";
            break;
        case 1:
            cell.iconView.image = [UIImage imageNamed:@"GalleryIcon.png"];
            cell.titleLabel.text = @"图集";
            break;
        case 2:
            cell.iconView.image = [UIImage imageNamed:@"SettingIcon.png"];
            cell.titleLabel.text = @"设定";
            break;
        default:
            break;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.titleLabel sizeToFit];
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
