//
//  EWebViewController.m
//  eViewer
//
//  Created by cookie on 8/8/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "EWebViewController.h"
#import "Masonry.h"

@interface EWebViewController () <UIScrollViewDelegate,UIWebViewDelegate>{
   
}

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) NSTimer *progressTimer;
@property (nonatomic)BOOL loadingFinish;
@property (nonatomic)NSInteger webViewLoads;
@property (strong, nonatomic)NSTimer *timeOutTimer;


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
        webView.delegate = self;
        webView.scrollView.delegate = self;
        webView.scalesPageToFit = YES;
        webView.autoresizesSubviews = YES;
        webView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        webView;
    });
    
    self.webViewLoads = 0;
   
    self.progressView = ({
        UIProgressView *view = [[UIProgressView alloc]init];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@3);
        }];
        view.trackTintColor = [UIColor clearColor];
        //view.backgroundColor = [UIColor whiteColor];
        view.progressTintColor = [UIColor colorWithHexString:@"1EA2E0"];
        view.progress = 0;
        view;
    });
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    self.progressTimer= [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    
    self.navigationController.navigationItem.title = self.title;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"1EA2E0"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"1EA2E0"]}];
    
    
    self.navigationItem.hidesBackButton = YES;
    weakify(self);
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] bk_initWithTitle:@"返回" style:UIBarButtonItemStylePlain handler:^(id sender) {
        strongify(self);
        if([self.webView canGoBack]){
            [self.webView goBack];
            [self resetProgressView];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    self.navigationItem.leftBarButtonItem = newBackButton;
    
    
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


#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.webViewLoads++;
    //DebugLog(@"++%ld",self.webViewLoads);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.webViewLoads--;
    //DebugLog(@"--%ld",self.webViewLoads);
    if(self.webViewLoads == 0){
        DebugLog(@"webViewFinish");
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    DebugLog(@"%@",error);
    //self.webViewLoads--;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        //NSLog(@"link clicked = %@",request.mainDocumentURL);
        [self resetProgressView];
    }
    
    //DebugLog(@"%@",request);
    
    return YES;
}

-(void)timerCallback {
    if (self.webViewLoads <= 0) {
        if (self.progressView.progress >= 1) {
            self.progressView.hidden = true;
            [self.progressTimer invalidate];
        }
        else {
            self.progressView.progress += 0.005;
        }
    }
    else {
        //DebugLog(@"%f",self.progressView.progress);
        self.progressView.progress += (1-self.progressView.progress) * 0.005;;
        if (self.progressView.progress >= 0.9) {
            self.progressView.progress = 0.9;
        }
    }
}

- (void)finishLoading{
    self.webViewLoads = 0;
}

- (void)resetProgressView{
    self.progressView.hidden = false;
    self.progressView.progress = 0;
    self.webViewLoads = 0;
    //[self.progressTimer invalidate];
    self.progressTimer= [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    
    self.timeOutTimer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(finishLoading) userInfo:nil repeats:NO];
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
