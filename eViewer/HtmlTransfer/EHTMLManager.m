//
//  HtmlTransfer.m
//  eViewer
//
//  Created by cookie on 6/14/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "EHTMLManager.h"
#import <AFNetworking/AFHTTPSessionManager.h>





@interface EHTMLManager()

@property (strong, nonatomic)AFHTTPSessionManager *manager;

@end

@implementation EHTMLManager

- (instancetype)init{
    self = [super init];
    if(self){
        _manager = [AFHTTPSessionManager manager];
    }
    return self;
}

- (void)test{
    NSURL *URL = [NSURL URLWithString:@"http://cn.engadget.com"];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session GET:URL.absoluteString parameters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *stringResponse = [[NSString alloc] initWithData:responseObject
                                                         encoding:NSUTF8StringEncoding];
        DebugLog(@"%@",stringResponse);
        //NSLog(@"成功");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error%@",error);
        NSLog(@"失败");
    }];
    
    
}

- (void)analysisHTMLDoc:(NSString *)doc{
    /*HTMLDocument *document = [HTMLDocument documentWithString:doc];
    HTMLElement *article = [document firstNodeMatchingSelector:@"article"];
    DebugLog(@"%@",article.textContent);*/
    
    
    
    
    
    
    
    
    
    
}

@end
