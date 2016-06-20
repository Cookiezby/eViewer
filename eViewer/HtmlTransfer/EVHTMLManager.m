//
//  EVHTMLManager.m
//  eViewer
//
//  Created by cookie on 6/20/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "EVHTMLManager.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <TFHpple.h>
#import "ArticleSimple.h"


@implementation EVHTMLManager

- (instancetype)init{
    self = [super init];
    if(self){
       
    }
    return self;
}

- (void)test{
    NSURL *URL = [NSURL URLWithString:@"http://cn.engadget.com"];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session GET:URL.absoluteString parameters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        //[self analysisHTMLData:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error%@",error);
        NSLog(@"失败");
    }];
    
}


- (NSMutableArray *)analysisHomePageHTMLData:(NSData *)data{
    TFHpple *parser = [[TFHpple alloc]initWithHTMLData:data];
    
    NSString *allArticleQuery = @"//article";
    NSArray *article = [parser searchWithXPathQuery:allArticleQuery];
    
    NSMutableArray *articleLists = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < article.count; i++) {
        TFHppleElement *element = article[i];
        TFHppleElement *post_header = [element firstChildWithClassName:@"post-header"];
        TFHppleElement *top = [post_header firstChildWithClassName:@"top"];
        TFHppleElement *headline = [top firstChildWithClassName:@"headline"];
        TFHppleElement *h2 = [headline firstChildWithClassName:@"h2"];
        TFHppleElement *a = [h2 firstChildWithTagName:@"a"];
        
        DebugLog(@"%@",a.text);
        DebugLog(@"%@",[element objectForKey:@"data-image"]);// Get the cover Image
        
        ArticleSimple *articleSimple = [[ArticleSimple alloc]init];
        articleSimple.title = a.text;
        articleSimple.coverImageURL = [element objectForKey:@"data-image"];
        [articleLists addObject:articleSimple];
    }
    
    return articleLists;
        
}
    
    /*double runTime = [[NSDate date]timeIntervalSinceDate:beforeDate]; // cost about 3.7ms
    
    DebugLog(@"%f",runTime*1000);
    
    
    NSString* titleQuery = @"//div[@class = 'headline']/h2[@class = 'h2']/a";
    NSArray *title = [parser searchWithXPathQuery:titleQuery];
    
    double secondTime = [[NSDate date]timeIntervalSinceDate:beforeDate] - runTime;
    DebugLog(@"%f",secondTime*1000); //cost about 5.0ms
    
    for (int i = 0; i < title.count; i++) {
        TFHppleElement *element = title[i];
        //DebugLog(@"%@",element.text);
    }*/
    
    
    



@end
