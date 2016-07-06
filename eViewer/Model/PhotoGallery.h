//
//  PhotoGallery.h
//  eViewer
//
//  Created by cookie on 7/6/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoGallery : NSObject

@property (strong, nonatomic) NSString *galleryTitle;
@property (nonatomic) NSInteger imageAmount;
@property (strong, nonatomic) NSArray *thumbImageLinkList;
@property (strong, nonatomic) NSString *galleryLink;

@end
