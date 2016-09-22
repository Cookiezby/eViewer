//
//  ProcessView.m
//  eViewer
//
//  Created by cookie on 7/20/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView()

@property (nonatomic) CGFloat progress;
@property (strong, nonatomic)UIView *blueView;

@end

@implementation ProgressView

- (instancetype)init{
    self = [super init];
    if(self){
        _progress = 0;
        self.layer.cornerRadius = self.frame.size.height/2;
        self.backgroundColor = [UIColor colorWithHexString:@"E9E9E9"];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _progress = 0;
        self.layer.cornerRadius = self.frame.size.height/2;
        self.backgroundColor = [UIColor colorWithHexString:@"E9E9E9"];
        _blueView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        _blueView.layer.cornerRadius = self.frame.size.height/2;
        _blueView.backgroundColor = [UIColor colorWithHexString:@"9EDBF2"];
        [self addSubview:_blueView];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGFloat width = _progress * (self.frame.size.width-10);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(ctx, 5, self.frame.size.height/2);
    CGContextAddLineToPoint(ctx, self.frame.size.width-5, self.frame.size.height/2);
    
    [[UIColor colorWithHexString:@"E9E9E9"]set];
    
    CGContextSetLineWidth(ctx, self.frame.size.height);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextStrokePath(ctx);
    
    CGContextMoveToPoint(ctx, 5, self.frame.size.height/2);
    CGContextAddLineToPoint(ctx, width, self.frame.size.height/2);
    
    [[UIColor colorWithHexString:@"9EDBF2"]set];
    
    CGContextSetLineWidth(ctx, self.frame.size.height);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGContextStrokePath(ctx);
}
 
*/
/*- (void)changeProgress:(CGFloat)progress animated:(BOOL)animated complete:(Completed)completed{
    CGFloat interval = progress - _progress;
    _progress = progress;
    CGFloat timeInterval = interval * 1.f;
    CGFloat width = _progress * self.frame.size.width;
    //DebugLog(@"%f",timeInterval);
    if(animated){
        [UIView animateWithDuration:timeInterval animations:^{
             self.blueView.frame = CGRectMake(0, 0, width, self.frame.size.height);
        } completion:^(BOOL finished) {
            if(completed){
                completed();
            }
        }];
    }else{
        self.blueView.frame = CGRectMake(0, 0, width, self.frame.size.height);
    }
}*/

- (void)changeProgress:(CGFloat)progress animated:(BOOL)animated{
    CGFloat interval = progress - _progress;
    _progress = progress;
    CGFloat timeInterval = interval * 1.f;
    CGFloat width = _progress * self.frame.size.width;
    //DebugLog(@"%f",timeInterval);
    if(animated){
        [UIView animateWithDuration:timeInterval animations:^{
            self.blueView.frame = CGRectMake(0, 0, width, self.frame.size.height);
        } completion:nil];
    }else{
        self.blueView.frame = CGRectMake(0, 0, width, self.frame.size.height);
    }

}


- (void)changeProgress:(CGFloat)progress{
    [self changeProgress:progress animated:NO];
}



@end
