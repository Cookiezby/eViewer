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
#import "GalleryDetail.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ECGView.h"



@interface ArticleDetailViewController () <EVHTMLDelegate,UITextViewDelegate>

@property (strong, nonatomic) UIImageView *coverImageView;
@property (strong, nonatomic) UITextView *testTextView;
@property (strong, nonatomic) NSMutableArray *galleryList;
@property (strong, nonatomic) UIView *headView;
@property (nonatomic) NSInteger titleHeight;
@property (strong, nonatomic) ECGView *ecgView;

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
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        textView.textContainerInset = UIEdgeInsetsZero;
        textView.editable = NO;
        textView.delegate = self;
        //textView.textAlignment = NSTextAlignmentJustified;
        textView.showsVerticalScrollIndicator = NO;
        textView.textContainerInset = UIEdgeInsetsMake(SCREEN_WIDTH/1.7 +85, 5, 0, 5);
        textView;
    });
    
    
    self.headView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/1.7 + 60)];
        [self.testTextView addSubview:view];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/1.7)];
        [view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.width.equalTo(@(SCREEN_WIDTH));
            make.height.equalTo(@(SCREEN_WIDTH/1.7));
        }];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        NSURL *url = [NSURL URLWithString:self.simpleArticle.coverImageURL];
        if(self.simpleArticle.coverImageURL.length!=0){
            [imageView sd_setImageWithURL:url];
        }else{
            imageView.image = [UIImage imageNamed:@"EngadgetLogo.png"];
        }
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, SCREEN_WIDTH/1.7 + 15, SCREEN_WIDTH-20, 0)];
        titleLabel.text = self.simpleArticle.title;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.simpleArticle.title];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = 10;
        
        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
        UIFont *font = [UIFont boldSystemFontOfSize:24];
        titleLabel.font = font;
        titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        titleLabel.numberOfLines = 0;
        titleLabel.attributedText = str;
        titleLabel.textColor = [UIColor darkGrayColor];
        [titleLabel sizeToFit];
        DebugLog(@"%f",titleLabel.frame.size.height);
        [view addSubview:titleLabel];
        self.titleHeight = titleLabel.frame.size.height;
       
        //view.backgroundColor = [UIColor darkGrayColor];
        view;
    });
    
    EVHTMLManager *manager = [[EVHTMLManager alloc]init];
    manager.delegate = self;
    
    
    self.ecgView = [[ECGView alloc]initWithFrame:CGRectMake(0, 0, 135, 90)];
    [self.view addSubview:_ecgView];
    [_ecgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.headView.mas_bottom).with.offset(self.titleHeight + 20);
        make.width.equalTo(@135);
        make.height.equalTo(@90);
    }];
    
    [manager getDetail:self.simpleArticle.detailURL withHandler:^(NSMutableAttributedString *string, NSMutableArray *galleryList) {
        [self.ecgView removeFromSuperview];
        self.testTextView.attributedText = string;
        self.galleryList = galleryList;
        //DebugLog(@"%ld",galleryList.count);
    }];
    
    self.testTextView.textContainerInset = UIEdgeInsetsMake(SCREEN_WIDTH/1.7 + self.titleHeight + 30, 5, 0, 5);

    
    //self.navigationItem.title = self.simpleArticle.title;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"EggIcon.png"]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    //[self.navigationController.navigationBar setHidden:YES];
}


#pragma mark - EVHTMLDelegate


- (void)refresImageAtRange:(NSRange)range toSize:(CGSize)size{
    //[self.testTextView.layoutManager setAttachmentSize:size forGlyphRange:range];
    //[self.testTextView.layoutManager ensureLayoutForCharacterRange:range];
    //[self.testTextView setNeedsDisplay];
    
    [self.testTextView.layoutManager invalidateLayoutForCharacterRange:range actualCharacterRange:NULL];
    [self.testTextView.layoutManager setAttachmentSize:size forGlyphRange:range];
}


#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    for(int i = 0; i < self.galleryList.count; i++){
        GalleryDetail *galleryDetail = self.galleryList[i];
        NSString *link = galleryDetail.galleryLink;
        //DebugLog(@"%@",link);
        if([[URL absoluteString]isEqualToString:link]){
            
            /*EVHTMLManager *manager = [[EVHTMLManager alloc]init];
            [manager getAllGalleryImage:@"" withCompleteHandler:^(NSMutableArray *thumbArray, NSMutableArray *fullSizeArray) {
            }];*/
            PhotoGalleryViewController * photoGalleyViewController = [[PhotoGalleryViewController alloc]init];
            photoGalleyViewController.galleryDetail = galleryDetail;
            //[self presentViewController:test animated:YES completion:nil];
            [self.navigationController pushViewController:photoGalleyViewController animated:YES];
            //DebugLog(@"%@",[URL absoluteString]);
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
