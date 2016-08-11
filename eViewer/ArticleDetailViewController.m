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
#import "EWebViewController.h"
#import "ArticleDetail.h"
#import <MBProgressHUD/MBProgressHUD.h>



@interface ArticleDetailViewController () <EVHTMLDelegate,UITextViewDelegate>

@property (strong, nonatomic) UIImageView *coverImageView;
@property (strong, nonatomic) UITextView *testTextView;
@property (strong, nonatomic) NSMutableArray *galleryList;
@property (strong, nonatomic) UIView *headView;
@property (strong, nonatomic) ECGView *ecgView;
@property (strong, nonatomic) UILabel *postTimeLabel;

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
        textView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"1EA2E0"]};
        textView;
    });
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"加载中=3=", @"HUD message title");

    EVHTMLManager *manager = [[EVHTMLManager alloc]init];
    manager.delegate = self;
    weakify(self);
    [manager getDetail:self.link withHandler:^(ArticleDetail *detail) {
        strongify(self);
        [hud hideAnimated:YES];
        //[self.ecgView removeFromSuperview];
        
        self.testTextView.attributedText = detail.context;
        self.galleryList = detail.photoGalleryList;
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
            NSURL *url = [NSURL URLWithString:detail.coverImageURL];
            if(detail.coverImageURL.length!=0){
                [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"PlaceHolder.png"]];
            }else{
                imageView.image = [UIImage imageNamed:@"EngadgetLogo.png"];
            }
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, SCREEN_WIDTH/1.7 + 15, SCREEN_WIDTH-20, 0)];
            titleLabel.text = detail.title;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:detail.title];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineSpacing = 10;
            
            [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
            UIFont *font = [UIFont boldSystemFontOfSize:20];
            titleLabel.font = font;
            titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
            titleLabel.numberOfLines = 0;
            titleLabel.attributedText = str;
            titleLabel.textColor = [UIColor darkGrayColor];
            [titleLabel sizeToFit];
            DebugLog(@"%f",titleLabel.frame.size.height);
            [view addSubview:titleLabel];
            self.testTextView.textContainerInset = UIEdgeInsetsMake(SCREEN_WIDTH/1.7 + titleLabel.frame.size.height + 30, 5, 0, 5);
            view;
        });
        
        self.postTimeLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:13];
            label.text = detail.postTime;
            [label sizeToFit];
            label.frame = CGRectMake(SCREEN_WIDTH - label.frame.size.width - 10, self.navigationController.navigationBar.frame.size.height/2 - label.frame.size.height/2, label.frame.size.width, label.frame.size.height);
            [self.navigationController.navigationBar addSubview:label];
            /*[label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@-10);
                make.right.equalTo(@-20);
            }];*/
            label;
        });
        //DebugLog(@"%ld",galleryList.count);
    }];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
          
}

- (void)setDetailView{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    //[self.navigationController.navigationBar setHidden:YES];
    /*[self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];*/
    //self.navigationController.hidesBarsOnSwipe = YES;
    [self.navigationController.navigationBar addSubview:self.postTimeLabel];
}

- (void)viewWillDisappear:(BOOL)animated{
    /*[self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];*/
    [self.navigationController setNavigationBarHidden:NO];
    //self.navigationController.hidesBarsOnSwipe = NO;
    [self.postTimeLabel removeFromSuperview];
}


#pragma mark - EVHTMLDelegate


- (void)refresImage:(NSTextAttachment*)textAttachment toSize:(CGSize)size{
    //[self.testTextView.layoutManager setAttachmentSize:size forGlyphRange:range];
    //[self.testTextView.layoutManager ensureLayoutForCharacterRange:range];
    //[self.testTextView setNeedsDisplay];
    [self.testTextView.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.testTextView.attributedText.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
         NSTextAttachment *attachment = (NSTextAttachment *)value;
        if(textAttachment == attachment){
            //DebugLog(@"find");
            [self.testTextView.layoutManager invalidateLayoutForCharacterRange:range actualCharacterRange:NULL];
            [self.testTextView.layoutManager setAttachmentSize:size forGlyphRange:range];
        }
    }];
    
    
    
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
    
    
    if([URL.absoluteString containsString:@"http://cn.engadget.com/20"]){
        ArticleDetailViewController *detailViewController = [[ArticleDetailViewController alloc]init];
        detailViewController.link = URL.absoluteString;
        [self.navigationController pushViewController:detailViewController animated:YES];

    }else{
        EWebViewController *webViewController = [[EWebViewController alloc]init];
        webViewController.url = URL;
        NSAttributedString *linkAttributdString = [self.testTextView.attributedText attributedSubstringFromRange:characterRange];
        webViewController.title = linkAttributdString.string;
        //UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:webViewController];
        //[self presentViewController:navigationController animated:YES completion:nil];
        //self.navigationController.navigationItem.backBarButtonItem.title = @"返回";
        
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    
    return NO;
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
