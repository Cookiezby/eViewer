//
//  PhotoGalleryViewController.h
//  eViewer
//
//  Created by cookie on 7/16/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoGallery.h"

@interface PhotoGalleryViewController : UIViewController

@property (strong, nonatomic) NSString *galleryLink;
@property (nonatomic) NSInteger photoAmount;
@property (strong, nonatomic) NSString *navigationTitle;

@property (strong, nonatomic)PhotoGallery *photoGallery;

@end
