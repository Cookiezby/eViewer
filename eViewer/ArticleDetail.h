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
@property (strong, nonatomic) NSArray<GalleryDetail *> *photoGalleryList;
@property (strong, nonatomic)NSString *title;
@property (strong, nonatomic)NSAttributedString *context;
@property (strong, nonatomic)NSString *coverImageURL;

@end
