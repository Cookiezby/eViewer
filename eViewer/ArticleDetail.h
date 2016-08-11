//
//  ArticleDetail.h
//  eViewer
//
//  Created by cookie on 6/20/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticleSimple.h"
#import "GalleryDetail.h"

@interface ArticleDetail : NSObject

//@property (strong, nonatomic) ArticleSimple *articleSimple;
@property (strong, nonatomic)NSMutableArray *photoGalleryList;
@property (strong, nonatomic)NSMutableArray *photoLinkList;
@property (strong, nonatomic)NSString *title;
@property (strong, nonatomic)NSMutableAttributedString *context;
@property (strong, nonatomic)NSString *coverImageURL;
@property (strong, nonatomic)NSString *postTime;

@end
