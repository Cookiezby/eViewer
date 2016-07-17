//
//  ZPresentationAnimator.h
//  eViewer
//
//  Created by cookie on 7/17/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPresentationAnimator : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithBool:(BOOL)isPresentation;

@end
