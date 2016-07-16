//
//  UIImage+Compress.h
//  eViewer
//
//  Created by cookie on 7/14/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compress)

+ (UIImage *)compressImage:(UIImage *)sourceImage ByRatio:(CGFloat)ratio toSize:(CGSize)size;

@end
