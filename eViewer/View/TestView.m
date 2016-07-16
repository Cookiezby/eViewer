//
//  TestView.m
//  eViewer
//
//  Created by cookie on 7/16/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "TestView.h"




@implementation TestView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
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
    
    UIGraphicsEndImageContext();
    
}


@end
