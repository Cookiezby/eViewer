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
#import "UIImage+Compress.h"
#import "NSString+DateTransfer.h"

const static CGFloat IMAGE_COMPRESS_RATIO = 0.8;

#define TEXT_FONT [UIFont systemFontOfSize:16]
@interface EVHTMLManager()

@property (strong,nonatomic) SDWebImageManager *sdManager;
@property (strong,nonatomic) NSMutableDictionary *tagAttributeDictionary;
@property (strong,nonatomic) NSMutableArray *galleryList;

@end


const NSString *baseURL = @"http://cn.engadget.com/page";
const NSString *engadgetHOST = @"http://cn.engadget.com";

@implementation EVHTMLManager

- (instancetype)init{
    self = [super init];
    if(self){
        _sdManager = [SDWebImageManager sharedManager];
        _galleryList = [[NSMutableArray alloc]init];
        _tagAttributeDictionary  = ({
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            paragraphStyle.lineHeightMultiple = 1.4;
            paragraphStyle.alignment = NSTextAlignmentJustified;
            NSDictionary *textAttribute = @{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:TEXT_FONT,NSForegroundColorAttributeName:[UIColor darkGrayColor]};
            dictionary[@"text"] = textAttribute;
            
            NSDictionary *aAttribute = @{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:TEXT_FONT,NSForegroundColorAttributeName:[UIColor blueColor]};
            dictionary[@"a"] = aAttribute;
            
            NSDictionary *sAttribute =  @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:TEXT_FONT,NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:[UIColor darkGrayColor],NSForegroundColorAttributeName:[UIColor darkGrayColor]};
            dictionary[@"s"] = sAttribute;
            
            NSMutableParagraphStyle *imgParagraphStyle = [[NSMutableParagraphStyle alloc]init];
            imgParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            imgParagraphStyle.lineHeightMultiple = 1.0;
            imgParagraphStyle.alignment = NSTextAlignmentNatural;

            NSDictionary *imgAttribute = @{NSParagraphStyleAttributeName:imgParagraphStyle};
            dictionary[@"img"] = imgAttribute;
            
            NSDictionary *h3Attribute =  @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor darkGrayColor]};
            dictionary[@"h3"] = h3Attribute;
            
            
            NSDictionary *strongAttribute = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor darkGrayColor]};
            dictionary[@"strong"] = strongAttribute;
            
            
            NSDictionary *imgDescriotionAttribute = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont boldSystemFontOfSize:13],NSForegroundColorAttributeName:[UIColor darkGrayColor]};
            dictionary[@"imgDp"] = imgDescriotionAttribute;

            dictionary;
        });
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
    NSString *URLString = @"http://cn.engadget.com/2016/07/08/oneplus-3-review/";
    //NSString *URLString = @"http://cn.engadget.com/2016/07/04/samsung-galaxy-c5-review/";
    NSURL *URL = [NSURL URLWithString:URLString];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session GET:URL.absoluteString parameters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        handler([self analysisDetailPageHTMLData2:responseObject],self.galleryList);
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error%@",error);
    }];

}

- (void)getAllGalleryImage:(NSString *)url withCompleteHandler:(GalleryPageCompleteHandler)handler{
    //NSString *urlString = @"http://cn.engadget.com/gallery/3-16/3973168/#!slide=3973173";
    NSURL *URL = [NSURL URLWithString:url];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session GET:URL.absoluteString parameters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        //[self analysisGalleryPageHTMLData:responseObject];
        NSDictionary *dict = [self analysisGalleryPageHTMLData:responseObject];
        
        //NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        //DebugLog(@"%@",result);
        handler(dict[@"thumbSize"],dict[@"fullSize"]);
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
        
        ArticleSimple *articleSimple = [[ArticleSimple alloc]init];
        articleSimple.title = a.text;
        articleSimple.detailURL = [a objectForKey:@"href"];
        articleSimple.coverImageURL = [element objectForKey:@"data-image"];
        articleSimple.postTime = [NSString timeSiceDate:[time objectForKey:@"datetime"]];
        articleSimple.author = author.text;
        [articleLists addObject:articleSimple];
    }
    
    return articleLists;
}


- (NSMutableAttributedString *)analysisDetailPageHTMLData2:(NSData *)data{
    TFHpple *parser = [[TFHpple alloc]initWithHTMLData:data];
    NSString *articleTextQuery = @"//div[@itemprop='text']";
    NSArray *elements = [parser searchWithXPathQuery:articleTextQuery];
    TFHppleElement *post_body = elements[0];
    NSArray *childrenElements = post_body.children;
    NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc]init];
    __weak __typeof__(self) weakSelf = self;
    [childrenElements enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        /**
         * Content这个 标签里面的子标签只有两种可能，1 TextNode 2 非TextNode， TextNode比较好处理，非TextNode需要不断的去遍历他的子标签，直到这个标签没有子标签为止，然后根据tag去处理这个标签的样式
         */
        __strong __typeof(self) strongSelf = weakSelf;
        TFHppleElement *child = (TFHppleElement *)obj;
        [strongSelf depthSearch:child addTo:detailText];
    }];
    
    return detailText;

}

- (NSMutableDictionary *)analysisGalleryPageHTMLData:(NSData *)data{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    NSMutableArray *fullSizeLinkList = [[NSMutableArray alloc]init];
    NSMutableArray *thumbSizeLinkList = [[NSMutableArray alloc]init];
    
    NSString *scalePre = @"http://o.aolcdn.com/dims-global/dims3/GLOB/thumbnail/200x200/quality/85/";
    
    TFHpple *parser = [[TFHpple alloc]initWithHTMLData:data];
    NSString *fullSizeQuery = @"//ul[@class='knot-slideshow-data']";
    NSArray *fullSize= [parser searchWithXPathQuery:fullSizeQuery];
    TFHppleElement *fullSizeElement = fullSize[0];
    [fullSizeElement.children enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TFHppleElement *li = (TFHppleElement *)obj;
        if([li.tagName isEqualToString:@"li"]){
            TFHppleElement *a = [li firstChildWithTagName:@"a"];
            NSString *imageLink = [a objectForKey:@"href"];
            //DebugLog(@"%@",imageLink);
            [fullSizeLinkList addObject:imageLink];
            
            NSString *thumbSizeLink = [NSString stringWithFormat:@"%@%@",scalePre,imageLink];
            [thumbSizeLinkList addObject:thumbSizeLink];
        }
    }];
    
    
    dictionary[@"fullSize"] = fullSizeLinkList;
    dictionary[@"thumbSize"] = thumbSizeLinkList;
    
    return dictionary;
}





- (void)depthSearch:(TFHppleElement *)element addTo:(NSMutableAttributedString *)attributedString{
    if(![element hasChildren]){
        [self addElement:element toAttributedString:attributedString];
    }else{
        if([[element objectForKey:@"class"]isEqualToString:@"post-gallery"]){
            [self addPostGalleryElement:element toAttributedString:attributedString];
        }else if([element.tagName isEqualToString:@"table"]){
            [self addTable:element toAttributedString:attributedString];
        }else if([[element objectForKey:@"class"]isEqualToString:@"read-more"]){
            //忽略这个标签
        }else{
            for (int i = 0; i < element.children.count; i++) {
                [self depthSearch:element.children[i] addTo:attributedString];
            }
        }
    }
}

- (void)addTable:(TFHppleElement *)element toAttributedString:(NSAttributedString *)attributedString{
    
}

- (void)addPostGalleryElement:(TFHppleElement *)element toAttributedString:(NSMutableAttributedString *)attributedString{
    __weak __typeof__(self) weakSelf = self;
    
    //NSMutableArray *galleryList = [[NSMutableArray alloc]init];
    PhotoGallery *photoGallery = [[PhotoGallery alloc]init];
    [element.children enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong __typeof__(self) strongSelf = weakSelf;
        TFHppleElement *child = (TFHppleElement *)obj;
        NSString *className = [child objectForKey:@"class"];
       
        if([className isEqualToString:@"title"]||[className isEqualToString:@"more gallery-link"]||[className isEqualToString:@"photo-number"]){
            NSMutableString *mutableString = [[NSMutableString alloc]initWithString:child.text];
            [mutableString appendString:@"\n"];
            NSMutableAttributedString *childAttributedString = [[NSMutableAttributedString alloc]initWithString:mutableString];
            if([className isEqualToString:@"title"]){
                photoGallery.galleryTitle = mutableString;
                [mutableString insertString:@"\n\n" atIndex:0];
                 NSMutableAttributedString *childAttributedString = [[NSMutableAttributedString alloc]initWithString:mutableString];
                [childAttributedString addAttributes:strongSelf.tagAttributeDictionary[@"text"] range:NSMakeRange(0, childAttributedString.length)];
                [attributedString appendAttributedString:childAttributedString];
            }else if([className isEqualToString:@"more gallery-link"]){
                [childAttributedString addAttributes:strongSelf.tagAttributeDictionary[@"a"] range:NSMakeRange(0, childAttributedString.length)];
                NSString *link = [NSString stringWithFormat:@"%@%@",engadgetHOST,[child objectForKey:@"href"]];
                photoGallery.galleryLink = link;
                [childAttributedString addAttribute: NSLinkAttributeName value:link range: NSMakeRange(0, childAttributedString.length)];
                [attributedString appendAttributedString:childAttributedString];
            }else if([className isEqualToString:@"photo-number"]){
                [childAttributedString addAttributes:strongSelf.tagAttributeDictionary[@"text"] range:NSMakeRange(0, childAttributedString.length)];
                [attributedString appendAttributedString:childAttributedString];
                NSString *photoAmount = [mutableString stringByReplacingOccurrencesOfString:@"[^0-9,]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [mutableString length])];
                //DebugLog(@"%@",photoAmount);
                photoGallery.photoAmount = [photoAmount integerValue];
            }
        }
        
    }];
    //[galleryList addObject:photoGallery];
    [self.galleryList addObject:photoGallery];
}

- (void)addElement:(TFHppleElement *)element toAttributedString:(NSMutableAttributedString *)attributedString{
    
    if([element isTextNode]){
        NSString *content = element.content;
        //DebugLog(@"%@ = %@",element.tagName,content);
        //NSString *correctString = [NSString stringWithCString:[content cStringUsingEncoding:NSISOLatin1StringEncoding] encoding:NSUTF8StringEncoding];
        //NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];
        //NSString *str = [content stringByAddingPercentEncodingWithAllowedCharacters:set];
        //DebugLog(@"%@",str);
        if(content.length < 5){
            content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        NSMutableAttributedString *textAttributedString = [[NSMutableAttributedString alloc]initWithString:content];
        if([element.parent.tagName isEqualToString:@"a"]){
            //DebugLog(@"%@",element.content);
            [textAttributedString addAttributes:self.tagAttributeDictionary[@"a"] range:NSMakeRange(0, content.length)];
             NSString *link = [NSString stringWithFormat:@"%@",[element.parent objectForKey:@"href"]];
            //DebugLog(@"%@",link);
            [textAttributedString addAttribute: NSLinkAttributeName value:link range: NSMakeRange(0, textAttributedString.length)];
        }else if([element.parent.tagName isEqualToString:@"s"]){
            [textAttributedString addAttributes:self.tagAttributeDictionary[@"s"] range:NSMakeRange(0, content.length)];
            if([element.parent.parent.tagName isEqualToString:@"a"]){
                [textAttributedString addAttributes:self.tagAttributeDictionary[@"a"] range:NSMakeRange(0, content.length)];
            }
        }else if([element.parent.tagName isEqualToString:@"h3"]){
            [textAttributedString addAttributes:self.tagAttributeDictionary[@"h3"] range:NSMakeRange(0, content.length)];
        }else if([element.parent.tagName isEqualToString:@"strong"]){
            [textAttributedString addAttributes:self.tagAttributeDictionary[@"strong"] range:NSMakeRange(0, content.length)];
        }else{
            [textAttributedString addAttributes:self.tagAttributeDictionary[@"text"] range:NSMakeRange(0, content.length)];
        }
        
        [attributedString appendAttributedString:textAttributedString];

    }
    
    
    if([element.tagName isEqualToString:@"img"]){
        //DebugLog(@"23333");
        UIImage *image = [UIImage imageNamed:@"placeholder.png"];
        NSTextAttachment *imgAttachment = [[NSTextAttachment alloc]init];
        imgAttachment.image = image;
        CGSize imageSize = CGSizeMake(SCREEN_WIDTH-10, image.size.height/(image.size.width/(SCREEN_WIDTH-10)));
    
        NSRange range = NSMakeRange(attributedString.length, 1);
        
        imgAttachment.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
        NSMutableAttributedString *imgAttributedString = [[NSMutableAttributedString alloc]initWithAttributedString:[NSAttributedString attributedStringWithAttachment:imgAttachment]];
        [imgAttributedString addAttributes:self.tagAttributeDictionary[@"img"] range:NSMakeRange(0, imgAttributedString.length)];
        [attributedString appendAttributedString:imgAttributedString];
        
        NSURL *imgURL = [[NSURL alloc]initWithString:[element objectForKey:@"src"]];
        
        
        if([_sdManager diskImageExistsForURL:imgURL]){
            //imgAttachment.bounds = CGRectMake(0, 0, 300, 100);
            //DebugLog(@"Exist");
            UIImage *cachedImage = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:[_sdManager cacheKeyForURL:imgURL]];
            imgAttachment.bounds = CGRectMake(0, 0, SCREEN_WIDTH-10, cachedImage.size.height/(cachedImage.size.width/(SCREEN_WIDTH-10)));
            UIImage *compressedImage = [UIImage compressImage:cachedImage ByRatio:IMAGE_COMPRESS_RATIO toSize:cachedImage.size];
            imgAttachment.image = compressedImage;
            //[self.delegate refresImageAtRange:range toSize:imgAttachment.bounds.size];
        }else{
            [_sdManager downloadImageWithURL:(NSURL *)imgURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                //show the download process here
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                imgAttachment.bounds = CGRectMake(0, 0, SCREEN_WIDTH-10, image.size.height/(image.size.width/(SCREEN_WIDTH-10)));
                //DebugLog(@"%f %f",imgAttachment.bounds.size.width,imgAttachment.bounds.size.height);
                UIImage *compressedImage = [UIImage compressImage:image ByRatio:IMAGE_COMPRESS_RATIO toSize:imgAttachment.bounds.size];
                imgAttachment.image = compressedImage;
                [[SDImageCache sharedImageCache]removeImageForKey:[_sdManager cacheKeyForURL:imgURL] fromDisk:YES];
                [[SDImageCache sharedImageCache]storeImage:compressedImage forKey:[_sdManager cacheKeyForURL:imgURL] toDisk:YES];
                [self.delegate refresImageAtRange:range toSize:imgAttachment.bounds.size];
            }];
        }
    }
    
}








@end
