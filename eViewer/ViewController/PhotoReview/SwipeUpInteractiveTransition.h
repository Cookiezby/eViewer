//
//  SwipeUpInteractiveTransition.h
//  eViewer
//
//  Created by cookie on 7/20/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SwipeUpInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic) BOOL interacting;
- (void)wireToViewController:(UIViewController *)viewController;

@end
