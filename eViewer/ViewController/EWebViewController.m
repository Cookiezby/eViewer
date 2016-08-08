//
//  EWebViewController.m
//  eViewer
//
//  Created by cookie on 8/8/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "EWebViewController.h"
#import "Masonry.h"

@interface EWebViewController ()

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIView *bottomView;

@end

@implementation EWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = ({
        UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:webView];
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            
        }];
        webView.scalesPageToFit = YES;
        webView.autoresizesSubviews = YES;
        webView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        webView;
    });
    
    /*self.bottomView = ({
        UIView *view = [[UIView alloc]init];
        [self.view addSubview:view];
        view.backgroundColor = [UIColor whiteColor];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@44);
        }];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        weakify(self);
        [backButton bk_whenTapped:^{
            strongify(self);
            [self.webView goBack];
        }];
        [view addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(@20);
        }];
        [backButton setBackgroundImage:[UIImage imageNamed:@"BarBackButton.png"] forState:UIControlStateNormal];
        
        view;
    });*/
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"1EA2E0"];
    weakify(self);
    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"DismissButton.png"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    self.navigationItem.leftBarButtonItem = leftBarbutton;
    self.navigationController.hidesBarsOnSwipe = YES;
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    NSLog(@"statusBar.backgroundColor--->%@",statusBar.backgroundColor);
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;//黑色
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
