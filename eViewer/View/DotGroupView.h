//
//  PointGroupView.h
//  eViewer
//
//  Created by cookie on 8/1/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DotGroupView : UIView

- (instancetype)initWithFrame:(CGRect)frame withDuration:(CGFloat) duration dotColor:(UIColor *)color;
- (void)pauseLayerAniamtion;
- (void)resumeLayerAnimation;

@end
