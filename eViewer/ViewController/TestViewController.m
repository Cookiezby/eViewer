//
//  TestViewController.m
//  eViewer
//
//  Created by cookie on 7/15/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "TestViewController.h"
#import "Masonry.h"
#import "PlanetView.h"
#import "ProgressView.h"
#import "DotGroupView.h"
#import "ECGView.h"
#define pi 3.1415926
#define   DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)

@interface TestViewController ()

@property (strong, nonatomic)PlanetView * galleryView;

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

    //__block int time = 0;
    
    /*UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(30, 100)];
    [path addArcWithCenter:CGPointMake(100,100) radius:70 startAngle:DEGREES_TO_RADIANS(-180) endAngle:DEGREES_TO_RADIANS(180) clockwise:YES];
    
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = [path CGPath];
    animation.duration = 3.0;
    animation.repeatCount = 10;
    //animation.autoreverses = YES;
    animation.calculationMode = kCAAnimationPaced;
    [testView.layer addAnimation:animation forKey:@"position"];*/
    
    
    //[view changeProgress:0.8 animated:YES];
    
    /*PlanetView *view = [[PlanetView alloc]initWithFrame:CGRectMake(100, 200, 25, 25)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
          
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 400, 100, 50);
    [self.view addSubview:button];
    [button setBackgroundColor:[UIColor blueColor]];
    
    [button bk_whenTapped:^{
        DebugLog(@"pressed");
        [view pauseLayerAniamtion];
    }];
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(0, 550, 100, 50);
    [self.view addSubview:button2];
    [button2 setBackgroundColor:[UIColor blueColor]];
    
    [button2 bk_whenTapped:^{
        DebugLog(@"pressed");
        [view resumeLayerAnimation];
    }];
    
    
    DotGroupView *view2 = [[DotGroupView alloc]initWithFrame:CGRectMake(50,100, 40, 10) withDuration:4 dotColor:[UIColor redColor]];
    [self.view addSubview:view2];*/
    
    
    ECGView *view = [[ECGView alloc]initWithFrame:CGRectMake(0, 100, 133, 64)];
    [self.view addSubview: view];

    
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
