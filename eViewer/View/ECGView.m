//
//  ECGView.m
//  eViewer
//
//  Created by cookie on 8/4/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "ECGView.h"

@interface ECGView()

@property (nonatomic) CGFloat angel;

@end

@implementation ECGView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        //self.backgroundColor = [UIColor blueColor];
        /*NSArray *peakList = @[@0,@0.15,@(-0.15),@0.05,@-0.05,@0];
        //int peakList[8] = [0,-10,30,10,15,-20,20,0];
        NSInteger allHeight = 0;
        for(int i = 1; i < peakList.count; i++){
            NSNumber *a = peakList[i];
            NSNumber *b = peakList[i-1];
            CGFloat interval = ABS(a.floatValue - b.floatValue) * frame.size.height;
            allHeight += interval;
        }
        
        DebugLog(@"%ld",allHeight);
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGFloat sideInterval = (frame.size.width - allHeight/4)/2;
        //path.lineJoinStyle = kCGLineJoinRound;
        [path moveToPoint:CGPointMake(0, frame.size.height/2)];
        [path addLineToPoint:CGPointMake(sideInterval, frame.size.height/2)];
        
        
        
        
        for(int i = 1; i < peakList.count - 1; i++){
            NSNumber *a = peakList[i];
            NSNumber *b = peakList[i-1];
            CGFloat y = frame.size.height/2 + a.floatValue * frame.size.height;
            CGFloat x =  ABS(a.floatValue - b.floatValue)*frame.size.height / 4 + path.currentPoint.x;
            DebugLog(@"x = %f y = %f",x,y);
            [path addLineToPoint:CGPointMake(x, y)];
        }
        [path addLineToPoint:CGPointMake(frame.size.width-sideInterval,frame.size.height/2)];
        [path addLineToPoint:CGPointMake(frame.size.width,frame.size.height/2)];

        CAShapeLayer *shape = [CAShapeLayer layer];
        shape.path = path.CGPath;
        shape.strokeColor = [UIColor darkGrayColor].CGColor;
        shape.fillColor = [UIColor clearColor].CGColor;
        shape.lineWidth = 4;
        shape.strokeStart = 0.0f;
        shape.strokeEnd = 1.0f;
        shape.lineCap = kCALineCapRound;

        [self.layer addSublayer:shape];*/
        
        self.layer.backgroundColor = [UIColor colorWithHexString:@"9ED8F2"].CGColor;
        CALayer *maskLayer = [CALayer layer];
        maskLayer.frame = self.layer.bounds;
        UIImage *image = [UIImage imageNamed:@"ECGMask2.png"];
        maskLayer.contents = (__bridge id)image.CGImage;
        self.layer.mask = maskLayer;
        
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 5, frame.size.height) cornerRadius:0];
        
        CAShapeLayer *shape = [CAShapeLayer layer];
        shape.path = path.CGPath;
        shape.fillColor = [UIColor colorWithHexString:@"1EA2E0"].CGColor;
        
        [self.layer addSublayer:shape];
        
        
        CABasicAnimation *animatoin = [CABasicAnimation animationWithKeyPath:@"position.x"];
        animatoin.duration = 2.0f;
        animatoin.autoreverses = NO;
        animatoin.repeatCount = INFINITY;
        animatoin.fromValue = @(0);
        animatoin.toValue = @(frame.size.width);
        
        [shape addAnimation:animatoin forKey:@"move"];
        
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)drawECGLine{
    
}


@end
