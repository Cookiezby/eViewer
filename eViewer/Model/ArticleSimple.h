//
//  ArticleSimple.h
//  eViewer
//
//  Created by cookie on 6/20/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleSimple : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *coverImageURL;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *postTime;
@property (strong, nonatomic) NSString *detailURL;

@end
