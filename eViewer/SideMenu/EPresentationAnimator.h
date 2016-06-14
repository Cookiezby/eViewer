//
//  EPresentationAnimator.h
//  eViewer
//
//  Created by cookie on 6/14/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EPresentationAnimator : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithBool:(BOOL)isPresenting;

@end
