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

@property (strong, nonatomic) NSMutableArray *dotList;
@property (strong, nonatomic) UIColor *dotColor;
@property (nonatomic) CGFloat duration;

@end

@implementation DotGroupView

- (instancetype)initWithFrame:(CGRect)frame withDuration:(CGFloat) duration dotColor:(UIColor *)color{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        _dotList = [[NSMutableArray alloc]init];
        _dotColor = color;
        _duration = duration;
        for(int i = 0; i < 4; i++){
            CAShapeLayer *circle = [CAShapeLayer layer];
            UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(i*frame.size.width/4 + frame.size.height/4, frame.size.height/4, frame.size.height/2, frame.size.height/2)];
            circle.fillColor = color.CGColor;
            circle.path = circlePath.CGPath;
            [self.layer addSublayer:circle];
            [_dotList addObject:circle];
        }
    }
    return self;
}

- (void)pauseLayerAniamtion{
    for(int i = 0; i < _dotList.count; i++){
        CAShapeLayer *circle = (CAShapeLayer *)_dotList[i];
        [circle removeAnimationForKey:@"color"];
    }
}


- (void)resumeLayerAnimation{
    for(int i = 0; i < _dotList.count; i++){
        CAShapeLayer *circle = (CAShapeLayer *)_dotList[i];
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        //animation.keyPath = @"opacity";
        //animation.values = [NSArray arrayWithObjects: (__bridge id)color.CGColor,
        //(id)color.CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)color.CGColor,(id)color.CGColor,nil];
        /*animation.values = @[(__bridge id)_dotColor.CGColor,
                             (__bridge id)_dotColor.CGColor,
                             (__bridge id)[UIColor whiteColor].CGColor,
                             (__bridge id)[UIColor whiteColor].CGColor,
                             (__bridge id)_dotColor.CGColor,
                             (__bridge id)_dotColor.CGColor];*/
        
        animation.values = @[@1,@1,@0,@0,@1,@1];
        
        animation.keyTimes = @[@0,@0.125,@0.25,@0.625,@0.75,@1];
        animation.duration = _duration;
        animation.calculationMode = kCAAnimationLinear;
        animation.repeatCount = INFINITY;
        animation.fillMode = kCAFillModeForwards;
        animation.additive = NO;
        animation.beginTime = CACurrentMediaTime() + i*_duration*0.125;
        //animation.removedOnCompletion = NO;
        [circle addAnimation:animation forKey:@"color"];
    }
    
    
}




@end
