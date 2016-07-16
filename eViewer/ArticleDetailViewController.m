//
//  ArticleDetailViewController.m
//  eViewer
//
//  Created by cookie on 6/28/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import <TTTAttributedLabel.h>
#import "EVHTMLManager.h"
#import "Masonry.h"
#import <YYText/YYText.h>
#import "PhotoGalleryViewController.h"

@interface ArticleDetailViewController () <EVHTMLDelegate,UITextViewDelegate>

@property (strong, nonatomic) UIImageView *coverImageView;
@property (strong, nonatomic) UITextView *testTextView;
@property (strong, nonatomic) NSMutableArray *galleryLinkList;


@end

@implementation ArticleDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.testTextView = ({
        UITextView *textView = [UITextView new];
        [self.view addSubview:textView];
        textView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
        //textView.layoutManager.allowsNonContiguousLayout = NO;
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@5);
            make.right.equalTo(@-10);
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        textView.textContainerInset = UIEdgeInsetsZero;
        textView.text = @"init text";
        textView.editable = NO;
        textView.delegate = self;
        //textView.textAlignment = NSTextAlignmentJustified;
        textView.showsVerticalScrollIndicator = NO;
        textView;
    });
    
    
    EVHTMLManager *manager = [[EVHTMLManager alloc]init];
    manager.delegate = self;
    
    [manager getDetail:self.simpleArticle.detailURL withHandler:^(NSMutableAttributedString *string, NSMutableArray *galleryLinkList) {
        self.testTextView.attributedText = string;
        self.galleryLinkList = galleryLinkList;
        DebugLog(@"%ld",galleryLinkList.count);
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableAttributedString *)setParagraph:(NSMutableAttributedString *)attributeString{
    //NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    //paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    //paragraphStyle.lineHeightMultiple = 1.4;
    //[attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributeString length])];
    
    
    return attributeString;
}


#pragma mark - EVHTMLDelegate
/*- (void)refreshTextViewAtRange:(NSRange)range{
    DebugLog(@"refresh");
    DebugLog(@"%ld,%ld",range.location,range.length);
    //[self.testTextView.layoutManager invalidateLayoutForCharacterRange:range actualCharacterRange:NULL];
   
}*/

- (void)refresImageAtRange:(NSRange)range toSize:(CGSize)size{
    //[self.testTextView.layoutManager setAttachmentSize:size forGlyphRange:range];
    //[self.testTextView.layoutManager ensureLayoutForCharacterRange:range];
    //[self.testTextView setNeedsDisplay];
    
    [self.testTextView.layoutManager invalidateLayoutForCharacterRange:range actualCharacterRange:NULL];
    [self.testTextView.layoutManager setAttachmentSize:size forGlyphRange:range];
}


#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    for(int i = 0; i < self.galleryLinkList.count; i++){
        NSString *link = (NSString *)self.galleryLinkList[i];
        if([[URL absoluteString]isEqualToString:link]){
            PhotoGalleryViewController * test = [[PhotoGalleryViewController alloc]init];
            //[self presentViewController:test animated:YES completion:nil];
            [self.navigationController pushViewController:test animated:YES];
            DebugLog(@"%@",[URL absoluteString]);
            return NO;
        }
    }
    
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
