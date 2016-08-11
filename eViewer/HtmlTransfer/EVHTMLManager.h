//
//  EVHTMLManager.h
//  eViewer
//
//  Created by cookie on 6/20/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticleDetail.h"

@protocol EVHTMLDelegate <NSObject>

@required
- (void)refresImage:(NSTextAttachment*)textAttachment toSize:(CGSize)size;

@end

typedef void (^HomePageCompleteHandler)(NSMutableArray *array);
typedef void (^DetailPageCompleteHandler)(ArticleDetail *articleDetail);
typedef void (^GalleryPageCompleteHandler)(NSMutableArray *thumbArray,NSMutableArray *fullSizeArray);
typedef void (^GalleryListCompleteHandler)(NSMutableArray *array);

@interface EVHTMLManager : NSObject



@property (strong, nonatomic) id<EVHTMLDelegate>delegate;

- (void)getPage:(NSInteger)page withHandler:(HomePageCompleteHandler)handler;
- (void)getDetail:(NSString *)url withHandler:(DetailPageCompleteHandler)handler;
- (void)getAllGalleryImage:(NSString *)url withCompleteHandler:(GalleryPageCompleteHandler)handler;
- (void)getGalleryListPage:(NSInteger)page withCompleteHandler:(GalleryListCompleteHandler)handler;
@end
