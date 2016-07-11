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
#import "PhotoGallery.h"
#import "ArticleDetail.h"
#import <SDWebImage/SDWebImageManager.h>
#import <YYText/YYText.h>
#import <QuartzCore/QuartzCore.h>


#define IS_IMAGE [childElement.tagName isEqualToString:@"div"] && [[childElement objectForKey:@"style"] isEqualToString:@"text-align: center;"]

@interface EVHTMLManager()

@property (strong,nonatomic) SDWebImageManager *sdManager;

@end


const NSString *baseURL = @"http://cn.engadget.com/page";

@implementation EVHTMLManager

- (instancetype)init{
    self = [super init];
    if(self){
        _sdManager = [SDWebImageManager sharedManager];
    }
    return self;
}

#pragma mark - Interface

- (void)getPage:(NSInteger)page withHandler:(HomePageCompleteHandler)handler{
    NSString *URLString = [NSString stringWithFormat:@"%@/%ld/",baseURL,page];
    //DebugLog(@"%@",URLString);
    NSURL *URL = [NSURL URLWithString:URLString];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session GET:URL.absoluteString parameters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        //[self analysisHTMLData:responseObject];
        handler([self analysisHomePageHTMLData:responseObject]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error%@",error);
        NSLog(@"失败");
    }];
}

- (void)getDetail:(NSString *)url withHandler:(DetailPageCompleteHandler)handler{
    //NSString *URLString = @"http://cn.engadget.com/2016/07/05/backpaix-hands-on/";
    NSURL *URL = [NSURL URLWithString:url];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session GET:URL.absoluteString parameters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        //[self analysisHTMLData:responseObject];
        
        if([self isReviewPage:url]){
            
        }else if([self isCommentPage:url]){
            
        }else{
            handler([self analysisDetailPageHTMLData:responseObject]);
        }
        //NSString *htmlString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        //DebugLog(@"%@",htmlString);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error%@",error);
        NSLog(@"失败");
    }];

}

- (void)getAllGalleryImage:(NSString *)url withCompleteHandler:(GalleryPageCompleteHandler)handler{
    //NSString *urlString = @"http://cn.engadget.com/gallery/backpaix/";
    NSURL *URL = [NSURL URLWithString:url];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session GET:URL.absoluteString parameters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        //[self analysisGalleryPageHTMLData:responseObject];
        handler([self analysisGalleryPageHTMLData:responseObject]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error%@",error);
        NSLog(@"失败");
    }];
}


#pragma mark - HTMLAnalysis

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
        articleSimple.detailURL = [a objectForKey:@"href"];
        articleSimple.coverImageURL = [element objectForKey:@"data-image"];
        articleSimple.postTime = [self timeSiceDate:[time objectForKey:@"datetime"]];
        articleSimple.author = author.text;
        [articleLists addObject:articleSimple];
    }
    
    return articleLists;
}



- (NSMutableAttributedString *)analysisDetailPageHTMLData:(NSData *)data{
    TFHpple *parser = [[TFHpple alloc]initWithHTMLData:data];
    NSString *articleTextQuery = @"//div[@itemprop='text']";
    NSArray *elements = [parser searchWithXPathQuery:articleTextQuery];
    TFHppleElement *post_body = elements[0];
    
    NSArray *childrenElements = post_body.children;
    //DebugLog(@"%ld",childrenElements.count);
    
    NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc]initWithString:@" "];
    
    //there are 4 kinds of elements in the detail page
    //1 text
    //2 text with link
    //3 image
    //4 image gallery (we need to take out the thumb image (most time 6 pieces)
    
    [childrenElements enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TFHppleElement *childElement = (TFHppleElement *)obj;
        //==============================================================
        //this is the link in the article (most time it is a part of the text, so we need to use the text
        if([childElement.tagName isEqualToString:@"a"]){
            if(childElement.text.length > 0){
                NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:childElement.text];
                [str addAttribute: NSLinkAttributeName value: @"http://www.google.com" range: NSMakeRange(0, str.length)];
                [detailText appendAttributedString:[self changeLineHeight:1.4 font:[UIFont systemFontOfSize:16] color:[UIColor blueColor] inAttributedString:str]];
                [detailText appendAttributedString:str];
               
            }
        }
        //==============================================================
        if([childElement.tagName isEqualToString:@"s"]){
            DebugLog(@"%@",childElement.text);
        }
        //==============================================================
        //this is the text in the detail article
        if([childElement isTextNode]){
            DebugLog(@"%@",childElement.content);
            NSMutableString *rawString = [[NSMutableString alloc]initWithString:childElement.content];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:rawString];
            [detailText appendAttributedString:[self changeLineHeight:1.4 font:[UIFont systemFontOfSize:16] color:[UIColor darkGrayColor] inAttributedString:attributedString]];
        }
        //==============================================================
        // this is the image element in the detail article
        if(([childElement.tagName isEqualToString:@"div"] && [[childElement objectForKey:@"style"] isEqualToString:@"text-align: center;"])||[childElement.tagName isEqualToString:@"img"]){
                      TFHppleElement *imageElement;
            if([childElement.tagName isEqualToString:@"img"]){
                imageElement = childElement;
            }else{
                imageElement = [childElement firstChildWithTagName:@"img"];
            }
            
            if(imageElement){
                UIImage *image = [UIImage imageNamed:@"placeholder.png"];
                NSTextAttachment *imgAttachment = [[NSTextAttachment alloc]init];
                imgAttachment.image = image;
                CGSize imageSize;
                NSString *imageSizeString = [imageElement objectForKey:@"style"];
                if(imageSizeString){
                    imageSize = [self getImageSize:imageSizeString];
                }else{
                    imageSize = CGSizeMake(0, 0);
                }
                imgAttachment.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:[NSAttributedString attributedStringWithAttachment:imgAttachment]];
                [detailText appendAttributedString:[self changeLineHeight:1.0 inAttributedString:attributedString]];
                
                NSURL *imgURL = [[NSURL alloc]initWithString:[imageElement objectForKey:@"src"]];
                [_sdManager downloadImageWithURL:(NSURL *)imgURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    imgAttachment.bounds = CGRectMake(0, 0, SCREEN_WIDTH-10, image.size.height/(image.size.width/(SCREEN_WIDTH-10)));
                    imgAttachment.image = image;
                }];
            }
        }
        //==============================================================
        //this is the gallery of this detail article (normally it has 1, or 2 galleries in one article)
        if([childElement .tagName isEqualToString:@"div"] && [[childElement objectForKey:@"class"]isEqualToString:@"post-gallery"]){
            //DebugLog(@"%ld",idx);
            PhotoGallery *gallery = [[PhotoGallery alloc]init];
            NSString *title = [childElement firstChildWithClassName:@"title"].text;
            gallery.galleryTitle = title;
            //DebugLog(@"%@",title);
            
            NSMutableArray *thumbnialImageLinkList = [[NSMutableArray alloc]init];
            TFHppleElement *thumbs = [childElement firstChildWithClassName:@"thumbs"];
            NSArray *thumbList = thumbs.children;
            [thumbList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TFHppleElement *thumb = (TFHppleElement *)obj;
                if([thumb.tagName isEqualToString:@"li"]){
                    NSString *link = [[[thumb firstChildWithClassName:@"gallery-link"]firstChildWithTagName:@"img"]objectForKey:@"src"];
                    //DebugLog(@"%@",link);
                    [thumbnialImageLinkList addObject:link];
                }
            }];
            gallery.thumbImageLinkList = [NSArray arrayWithArray:thumbnialImageLinkList];
            
            NSString *moreImageLink = [[childElement firstChildWithClassName:@"more gallery-link"] objectForKey:@"href"];
            //DebugLog(@"more = %@",moreImageLink);
            gallery.galleryLink = moreImageLink;
            
            NSString *imageAmountText = [childElement firstChildWithClassName:@"photo-number"].text;
            NSArray *stringArray = [imageAmountText componentsSeparatedByString:@" "];
            NSInteger imageAmount = [(NSString *)stringArray[0] intValue];
            //DebugLog(@"%ld",imageAmount);
            gallery.imageAmount = imageAmount;
            
            NSMutableString *mutableString = [[NSMutableString alloc]init];
            [mutableString appendString:[NSString stringWithFormat:@"%@\n",title]];
            [mutableString appendString:@"浏览图集\n"];
            [mutableString appendString:imageAmountText];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:mutableString attributes:nil];
            [detailText appendAttributedString:attributedString];
            NSAttributedString *line = [[NSAttributedString alloc]initWithString:@"\n\n"];
            [detailText insertAttributedString:line atIndex:0];
        }
    }];
    
    
    return detailText;
}


- (NSMutableAttributedString *)analysisDetailReviewPage:(NSData *)data{
    NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc]init];
    return detailText;
}

- (NSMutableAttributedString *)analysisDetailCommentPage:(NSData *)data{
    NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc]init];
    return detailText;
}


- (NSMutableArray *)analysisGalleryPageHTMLData:(NSData *)data{
    NSMutableArray *imageLinkList = [[NSMutableArray alloc]init];
    
    TFHpple *parser = [[TFHpple alloc]initWithHTMLData:data];
    NSString *galleryQuery = @"//ul[@class='knot-slideshow-data']";
    NSArray *resultElements= [parser searchWithXPathQuery:galleryQuery];
    TFHppleElement *galleryElement = resultElements[0];
    [galleryElement.children enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TFHppleElement *li = (TFHppleElement *)obj;
        if([li.tagName isEqualToString:@"li"]){
            TFHppleElement *a = [li firstChildWithTagName:@"a"];
            NSString *imageLink = [a objectForKey:@"href"];
            //DebugLog(@"%@",imageLink);
            [imageLinkList addObject:imageLink];
        }
    }];
    
    return imageLinkList;
}




#pragma mark - TimeHelper

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

- (CGSize)getImageSize:(NSString *)string{
    NSArray *size = [string componentsSeparatedByString:@"; "];
    
    NSString *heightString;
    NSString *widthString;
    if([(NSString *)size[0] containsString:@"width"]){
        heightString = [size[1] componentsSeparatedByString:@": "][1];
        widthString = [size[0]componentsSeparatedByString:@": "][1];
    }else{
        heightString = [size[0] componentsSeparatedByString:@": "][1];
        widthString = [size[1]componentsSeparatedByString:@": "][1];
    }
    NSInteger height = [[heightString substringWithRange:NSMakeRange(0, heightString.length-2)] intValue];
    NSInteger width = [[widthString substringWithRange:NSMakeRange(0, widthString.length-2)] intValue];
    
    return CGSizeMake(SCREEN_WIDTH-10, height/(width/(SCREEN_WIDTH-10)));
}

- (BOOL)isReviewPage:(NSString *)url{
    return [url containsString:@"-review"];
}

- (BOOL)isCommentPage:(NSString *)url{
    return [url containsString:@"comments-of-the-week"];
}

- (NSMutableAttributedString *)changeLineHeight:(CGFloat)height font:(UIFont *)font color:(UIColor *)color inAttributedString:(NSMutableAttributedString *)attributedString{
    
    attributedString = [self changeLineHeight:height inAttributedString:attributedString];
    
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [attributedString length])];

    NSDictionary *attribute = @{NSForegroundColorAttributeName:color};
    [attributedString addAttributes:attribute range:NSMakeRange(0, attributedString.length)];

    return attributedString;
}

- (NSMutableAttributedString *)changeLineHeight:(CGFloat)height inAttributedString:(NSMutableAttributedString *)attributedString{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineHeightMultiple = height;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    return attributedString;
}



@end
