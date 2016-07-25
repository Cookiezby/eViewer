//
//  ZPhotoReviewViewController.h
//  eViewer
//
//  Created by cookie on 7/17/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,SOURCE_TYPE){
    IMAGE_TYPE = 0,
    LINK_TYPE = 1,
};

@interface ZPhotoReviewViewController : UIViewController <UIViewControllerTransitioningDelegate>

@property (strong, nonatomic)NSMutableArray *source;
@property (nonatomic)NSInteger selectedIndex;

@end
