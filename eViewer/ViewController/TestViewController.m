//
//  TestViewController.m
//  eViewer
//
//  Created by cookie on 7/15/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "TestViewController.h"
#import "Masonry.h"
#import "TestView.h"
#import "ProgressView.h"

@interface TestViewController ()

@property (strong, nonatomic)TestView * galleryView;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*self.galleryView = ({
        TestView *view = [[TestView alloc]init];
        [self.view addSubview:view];
        view.backgroundColor = [UIColor whiteColor];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.equalTo(@300);
            make.height.equalTo(@300);
        }];
        
        view;
    });*/
    
    
    ProgressView *view = [[ProgressView alloc]initWithFrame:CGRectMake(0, 0, 200, 5)];
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@200);
        make.height.equalTo(@5);
    }];
    
    
    DebugLog(@"%f",view.frame.origin.x);
    
    //[view changeProgress:0.8 animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIImage *)drawImage{
    UIGraphicsBeginImageContext(CGSizeMake(300, 100));
    CGFloat imageWidth = 60;
    //CGContextStrokeRectWithWidth(ctx, CGRectMake(0,0, self.frame.size.width, imageWidth + 10), 0.5);
    
    //UIGraphicsBeginImageContext(self.frame.size);
    
    for (int i = 1; i < 5; i++){
        NSString *imageName = [NSString stringWithFormat:@"%d.jpg",i];
        UIImage *image = [UIImage imageNamed:imageName];
        [image drawInRect:CGRectMake(10+(i-1)*(imageWidth+10), 5, imageWidth, imageWidth)];
    }
    
    UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return tempImage;
};

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
