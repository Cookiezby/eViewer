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


@interface ArticleDetailViewController ()

@property (strong, nonatomic) UIImageView *coverImageView;
@property (strong, nonatomic) UITextView *testTextView;

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
        textView.textAlignment = NSTextAlignmentNatural;
        textView.showsVerticalScrollIndicator = NO;
        textView;
    });
    
    
    EVHTMLManager *manager = [[EVHTMLManager alloc]init];
    [manager getDetail:self.simpleArticle.detailURL withHandler:^(NSMutableAttributedString *string) {
        self.testTextView.attributedText = string;
        DebugLog(@"%@",string.string);
        
        DebugLog(@"%f",self.testTextView.textContainer.size.height);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
