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
    DebugLog(@"%@",URLString);
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
        
        DebugLog(@"%@",a.text);
        DebugLog(@"%@",[element objectForKey:@"data-image"]);// Get the cover Image
        DebugLog(@"%@",author.text);
        //DebugLog(@"%@",time.text);
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        //[format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [format setDateFormat:@"EEEE, dd MM yyyy HH:mm:ss"];
        
        NSRange range = NSMakeRange(0, [time objectForKey:@"datetime"].length-6);
        
        NSString *newString = [[time objectForKey:@"datetime"] substringWithRange:range];
        
        //DebugLog(@"%@",newString);
        NSDate *myDate = [format dateFromString:newString];
        
       
        NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT-4:00"];
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];

        
        NSDate *sourceDate = myDate;
        NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
        NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
        NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
        
        //DebugLog(@"%f",interval);
        NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc]init];
        [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        DebugLog(@"post date%@",destinationDate);
        
        
        DebugLog(@"now date%@",[NSDate date]);
        
        
        DebugLog(@"%@", [self remaningTime:destinationDate endDate:[NSDate date]]);
        
        //NSDate *now = [NSDate date];
        //NSCalendar *c = [NSCalendar currentCalendar];
        //NSDateComponents* components = [c components:(NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:myDate toDate:now options:0] ;
        //NSLog(@"%ld years, %ld hours, %ld minutes, %ld seconds",  components.year, components.hour, components.minute, components.second) ;
        
        ArticleSimple *articleSimple = [[ArticleSimple alloc]init];
        articleSimple.title = a.text;
        articleSimple.coverImageURL = [element objectForKey:@"data-image"];
        [articleLists addObject:articleSimple];
    }
    
    return articleLists;
        
}


- (NSString*)remaningTime:(NSDate*)startDate endDate:(NSDate*)endDate{
    
    NSDateComponents *components;
    NSInteger days;
    NSInteger hour;
    NSInteger minutes;
    NSString *durationString;
    
    
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute
                                                 fromDate: startDate toDate: endDate options: 0];
    days = [components day];
    hour=[components hour];
    minutes=[components minute];
    
    if(days>0){
        
        if(days>1){
            durationString=[NSString stringWithFormat:@"%ld days",days];
        }
        else{
            durationString=[NSString stringWithFormat:@"%ld day",days];
            
        }
        return durationString;
    }
    
    if(hour>0){
        
        if(hour>1){
            durationString=[NSString stringWithFormat:@"%ld hours",hour];
        }
        else{
            durationString=[NSString stringWithFormat:@"%ld hour",hour];
            
        }
        return durationString;
    }
    
    if(minutes>0){
        
        if(minutes>1){
            durationString=[NSString stringWithFormat:@"%ld minutes",minutes];
        }
        else{
            durationString=[NSString stringWithFormat:@"%ld minute",minutes];
            
        }
        return durationString;
    }
    
    return @"";
}

- (NSDate *)dateFromString:(NSString *)string{
    
    
    return [NSDate date];
}
    
    



@end
