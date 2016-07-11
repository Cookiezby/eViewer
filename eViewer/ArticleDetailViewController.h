//
//  ArticleDetailViewController.h
//  eViewer
//
//  Created by cookie on 6/28/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleDetail.h"

@interface ArticleDetailViewController : UIViewController

@property (strong, nonatomic)ArticleDetail *detail;
@property (strong, nonatomic)ArticleSimple *simpleArticle;
@property (strong, nonatomic)NSMutableAttributedString *attributedString;

@end
