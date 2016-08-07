//
//  TestView.m
//  eViewer
//
//  Created by cookie on 7/16/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "PlanetView.h"


#define pi 3.1415926
#define   DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)

@interface PlanetView()

@property (nonatomic) CGFloat radius;

@end

@implementation PlanetView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        _radius = frame.size.width/2;
       
        self.backgroundColor = [UIColor clearColor];
        UIBezierPath *borderPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        //[borderPath addArcWithCenter:CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2) radius:CGRectGetHeight(self.frame)/2-5 startAngle:0 endAngle:360 clockwise:YES];
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.path = borderPath.CGPath;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = [UIColor colorWithHexString:@"1EA2E0"].CGColor;
        borderLayer.lineWidth = 1;
        borderLayer.strokeStart = 0.0f;
        borderLayer.strokeEnd = 1.0f;
        [self.layer addSublayer:borderLayer];
        
        
        UIBezierPath *sunPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_radius/3.0, _radius/3.0, _radius/3.0, _radius/3.0)];
        CAShapeLayer *sunLayer = [CAShapeLayer layer];
        sunLayer.path = sunPath.CGPath;
        sunLayer.fillColor = [UIColor colorWithHexString:@"1EA2E0"].CGColor;
        //[self.layer addSublayer:sunLayer];
        
        
        CGFloat earthRadius = _radius / 2.0;
        UIBezierPath *earthPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_radius-earthRadius/2.0, -earthRadius/2.0, earthRadius, earthRadius)];
        CAShapeLayer *earthLayer = [CAShapeLayer layer];
        earthLayer.path = earthPath.CGPath;
        earthLayer.fillColor = [UIColor colorWithHexString:@"FC7586"].CGColor;
        [self.layer addSublayer:earthLayer];
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    /*// Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //CGContextAddEllipseInRect(ctx, CGRectMake(10, 10, 100, 50));
    //CGContextAddRect(ctx, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    [[UIColor darkGrayColor]set];
    //CGContextFillPath(ctx);
    //self.backgroundColor = [UIColor lightGrayColor];
    CGFloat imageWidth = (self.frame.size.height - 50)/4;
    CGContextStrokeRectWithWidth(ctx, CGRectMake(0,0, self.frame.size.width, imageWidth + 10), 0.5);
    
    UIGraphicsBeginImageContext(self.frame.size);
    
    for (int i = 1; i < 5; i++){
        NSString *imageName = [NSString stringWithFormat:@"%d.jpg",i];
        UIImage *image = [UIImage imageNamed:imageName];
        [image drawInRect:CGRectMake(10+(i-1)*(imageWidth+10), 5, imageWidth, imageWidth)];
    }
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    [finalImage drawInRect:CGRectMake(0, 100, 200, 50)];
    
    UIGraphicsEndImageContext();*/
}


- (void)pauseLayerAniamtion{
    [self.layer removeAnimationForKey:@"rotation"];
}

- (void)resumeLayerAnimation{
   
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.byValue = [NSNumber numberWithFloat:2.0f*M_PI];
    spinAnimation.duration = 1.5f;
    spinAnimation.repeatCount = INFINITY;
    
    [self.layer addAnimation:spinAnimation forKey:@"rotation"];
}

/**
 *  如果需要动画暂停恢复的话
 动画恢复
 CFTimeInterval pausedTime = [self.layer timeOffset];
 self.layer.speed = 1.0;
 self.layer.timeOffset = 0.0;
 self.layer.beginTime = 0.0;
 CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
 self.layer.beginTime = timeSincePause;
 
 动画暂停
 CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
 self.layer.speed = 0.0;
 self.layer.timeOffset = pausedTime;

 */


@end
