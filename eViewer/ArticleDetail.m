//
//  ArticleDetail.m
//  eViewer
//
//  Created by cookie on 6/20/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "ArticleDetail.h"

@implementation ArticleDetail

- (instancetype)init{
    self = [super init];
    if(self){
        self.photoGalleryList = [[NSMutableArray alloc]init];
        self.photoLinkList = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
