//
//  PointGroupView.m
//  eViewer
//
//  Created by cookie on 8/1/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "DotGroupView.h"

#define pi 3.1415926
#define   DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)

@interface DotGroupView()

@end

@implementation DotGroupView

- (instancetype)initWithFrame:(CGRect)frame withDuration:(CGFloat) duration dotColor:(UIColor *)color{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        
        for(int i = 0; i < 4; i++){
            CAShapeLayer *circle = [CAShapeLayer layer];
            UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(i*frame.size.width/4 + frame.size.height/4, frame.size.height/4, frame.size.height/2, frame.size.height/2)];
            circle.fillColor = color.CGColor;
            circle.path = circlePath.CGPath;
            //circle.strokeColor = [UIColor darkGrayColor].CGColor;
            //circle.lineWidth = 2;
            //circle.strokeStart = 0.0f;
            //circle.strokeEnd = 1.0f;
            
            
            
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"fillColor";
            animation.values = [NSArray arrayWithObjects: (id)color.CGColor,
                            (id)color.CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)color.CGColor,(id)color.CGColor,nil];
           
            animation.keyTimes = @[@0,@0.125,@0.25,@0.625,@0.75,@1];
            animation.duration = duration;
            animation.calculationMode = kCAAnimationCubic;
            animation.repeatCount = INFINITY;
            animation.fillMode = kCAFillModeForwards;
            animation.additive = YES;
            animation.beginTime = CACurrentMediaTime() + i*duration*0.125;
                       
            [circle addAnimation:animation forKey:@"color"];
            [self.layer addSublayer:circle];
            
        }
    }
    return self;
}

- (void)pauseLayerAniamtion{
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = pausedTime;
}


- (void)resumeLayerAnimation{
    CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.speed = 1.0;
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
}




@end
