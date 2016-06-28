//
//  ESideMenuViewController.h
//  eViewer
//
//  Created by cookie on 6/26/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVNaviViewController.h"

@interface EVSideViewController : UIViewController

@property (strong, nonatomic) EVNaviViewController *contentViewController;
@property (strong, nonatomic) NSMutableArray *contentViewControllerList;

- (void)showMenu;
- (void)hideMenu;
- (void)changeToViewControllerAtIndex:(NSInteger)index;


@end
