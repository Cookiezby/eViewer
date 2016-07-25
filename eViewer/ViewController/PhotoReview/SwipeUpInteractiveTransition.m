//
//  SwipeUpInteractiveTransition.m
//  eViewer
//
//  Created by cookie on 7/20/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "SwipeUpInteractiveTransition.h"

@interface SwipeUpInteractiveTransition()


@property (strong, nonatomic)UIViewController *presentingVC;

@property (nonatomic)BOOL shouldComplete;


@end


@implementation SwipeUpInteractiveTransition

- (void)wireToViewController:(UIViewController *)viewController{
    self.presentingVC = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}


- (void)prepareGestureRecognizerInView:(UIView *)view{
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:gesture];
}



-(CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            // 1. Mark the interacting flag. Used when supplying it in delegate.
            self.interacting = YES;
            [self.presentingVC dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateChanged: {
            // 2. Calculate the percentage of guesture
            //DebugLog(@"%f",translation.y);
            if(translation.y < 0){
                CGFloat fraction = -translation.y / (400);
                //Limit it between 0 and 1
                fraction = fminf(fmaxf(fraction, 0.0), 1.0);
                self.shouldComplete = (fraction > 0.8);
                
                [self updateInteractiveTransition:fraction];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            // 3. Gesture over. Check if the transition should happen or not
            self.interacting = NO;
            if (!self.shouldComplete || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                DebugLog(@"cancel");
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}


@end
