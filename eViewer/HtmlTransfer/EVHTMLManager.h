//
//  EVHTMLManager.h
//  eViewer
//
//  Created by cookie on 6/20/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EVHTMLDelegate <NSObject>

@required
- (void)refresImageAtRange:(NSRange)range toSize:(CGSize)size;

@end

typedef void (^HomePageCompleteHandler)(NSMutableArray *array);
typedef void (^DetailPageCompleteHandler)(NSMutableAttributedString *string, NSMutableArray* galleryLinkList);
typedef void (^GalleryPageCompleteHandler)(NSMutableArray *array);

@interface EVHTMLManager : NSObject



@property (strong, nonatomic) id<EVHTMLDelegate>delegate;

- (void)getPage:(NSInteger)page withHandler:(HomePageCompleteHandler)handler;
- (void)getDetail:(NSString *)url withHandler:(DetailPageCompleteHandler)handler;
- (void)getAllGalleryImage:(NSString *)url withCompleteHandler:(GalleryPageCompleteHandler)handler;

@end
