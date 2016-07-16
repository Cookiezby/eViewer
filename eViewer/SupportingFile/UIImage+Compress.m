//
//  UIImage+Compress.m
//  eViewer
//
//  Created by cookie on 7/14/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "UIImage+Compress.h"

@implementation UIImage (Compress)

+ (UIImage *)compressImage:(UIImage *)sourceImage ByRatio:(CGFloat)ratio toSize:(CGSize)size{
    NSData *imageData = UIImageJPEGRepresentation(sourceImage, ratio);
    //DebugLog(@"%ld",imageData.length);

    UIImage *targetImage = [UIImage imageWithData:imageData];
    
    UIGraphicsBeginImageContext(size);
    [targetImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

@end
