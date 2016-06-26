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

const NSString *baseURL = @"http://cn.engadget.com/page";

@implementation EVHTMLManager

- (instancetype)init{
    self = [super init];
    if(self){
       
    }
    return self;
}

- (void)getPage:(NSInteger)page withHandler:(HomePageCompleteHandler)hander{
    NSString *URLString = [NSString stringWithFormat:@"%@/%ld/",baseURL,page];
    //DebugLog(@"%@",URLString);
    NSURL *URL = [NSURL URLWithString:URLString];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session GET:URL.absoluteString parameters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        //[self analysisHTMLData:responseObject];
        hander([self analysisHomePageHTMLData:responseObject]);
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
        
        
        TFHppleElement *info = [top firstChildWithClassName:@"info"];
        TFHppleElement *byline = [info firstChildWithClassName:@"byline"];
        TFHppleElement *strong = [byline firstChildWithTagName:@"strong"];
        TFHppleElement *author = [strong firstChildWithTagName:@"a"];
        
        TFHppleElement *time = [byline firstChildWithTagName:@"time"];
        
        /*
        DebugLog(@"%@",a.text);
        DebugLog(@"%@",[element objectForKey:@"data-image"]);// Get the cover Image
        DebugLog(@"%@",author.text);
        DebugLog(@"%@",[self timeSiceDate:[time objectForKey:@"datetime"]]);
        */
        
        ArticleSimple *articleSimple = [[ArticleSimple alloc]init];
        articleSimple.title = a.text;
        articleSimple.coverImageURL = [element objectForKey:@"data-image"];
        articleSimple.postTime = [self timeSiceDate:[time objectForKey:@"datetime"]];
        articleSimple.author = author.text;
        [articleLists addObject:articleSimple];
    }
    
    return articleLists;
        
}

- (NSString *)timeSiceDate:(NSString *)string{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"EEEE, dd MM yyyy HH:mm:ss"];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    //原文的格式 最后是5位时区信息，这边截取后，将时间转化为GMT时间
    NSRange range = NSMakeRange(0, string.length-6);
    NSString *dateString = [string substringWithRange:range];
    
    NSDate *myDate = [format dateFromString:dateString];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT-4:00"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];

    NSDate *sourceDate = myDate;
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
    
    return [self remaningTime:destinationDate endDate:[NSDate date]];
}


- (NSString *)remaningTime:(NSDate*)startDate endDate:(NSDate*)endDate{
    
    NSDateComponents *components;
    NSInteger days;
    NSInteger hour;
    NSInteger minutes;
    
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute
                                                 fromDate: startDate toDate: endDate options: 0];
    days = [components day];
    hour=[components hour];
    minutes=[components minute];
    DebugLog(@"%@",startDate);
    
    if(days>0){
        return [NSString stringWithFormat:@"%ld天前",days];
    }
    
    if(hour>0){
        return [NSString stringWithFormat:@"%ld小时前",hour];
    }
    
    if(minutes>0){
        return [NSString stringWithFormat:@"%ld分钟前",minutes];
    }
    
    return @"";
}


@end
