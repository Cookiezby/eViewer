//
//  ProcessView.h
//  eViewer
//
//  Created by cookie on 7/20/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Completed)();

@interface ProgressView : UIView

//- (void)setProgress:(CGFloat)progress;
- (void)changeProgress:(CGFloat)progress animated:(BOOL)animated complete:(Completed)completed;

@end
