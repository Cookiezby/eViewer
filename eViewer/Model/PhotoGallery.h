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
@property (strong, nonatomic) NSMutableArray *thumbImageLinkList;
@property (strong, nonatomic) NSMutableArray *fullSizeLinkList;
@property (strong, nonatomic) NSString *galleryLink;
@property (nonatomic) NSInteger photoAmount;

@end
