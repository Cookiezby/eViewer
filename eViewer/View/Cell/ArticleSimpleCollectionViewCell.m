//
//  ArticleSimpleCollectionViewCell.m
//  eViewer
//
//  Created by cookie on 6/30/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "ArticleSimpleCollectionViewCell.h"
#import <Masonry/Masonry.h>

@implementation ArticleSimpleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.contentView.backgroundColor = [UIColor whiteColor];
    if(self){
        self.coverImageView = ({
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [self.contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@0);
                make.left.equalTo(@0);
                make.right.equalTo(@0);
                make.bottom.equalTo(@-70);
            }];
            imageView;
        });
        
        self.titleLabel = ({
            UILabel *label = [[UILabel alloc]init];
            [self.contentView addSubview:label];
            label.font = [UIFont systemFontOfSize:15];
            label.lineBreakMode = NSLineBreakByCharWrapping;
            label.numberOfLines = 0;
            label.textColor = [UIColor darkGrayColor];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@5);
                make.right.equalTo(@-5);
                make.top.equalTo(self.coverImageView.mas_bottom).with.offset(5);
            }];
            label;
        });
        
        self.postTimeLabel = ({
            UILabel *label = [[UILabel alloc]init];
            [self.contentView addSubview:label];
            label.font = [UIFont systemFontOfSize:10];
            label.textColor = [UIColor darkGrayColor];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@-5);
                make.left.equalTo(@10);
            }];
            label;
        });
        
        self.authorLabel = ({
            UILabel *label = [[UILabel alloc]init];
            [self.contentView addSubview:label];
            label.textColor = [UIColor colorWithHexString:@"1EA2E0"];
            label.font = [UIFont systemFontOfSize:12];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@-10);
                make.bottom.equalTo(@-5);
            }];
            label;
        });
        
        
        UILabel *authorPre = [[UILabel alloc]init];
        [self.contentView addSubview:authorPre];
        authorPre.text = @"作者";
        authorPre.textColor = [UIColor darkGrayColor];
        authorPre.font = [UIFont systemFontOfSize:12];
        [authorPre mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.authorLabel.mas_left).with.offset(-5);
            make.bottom.equalTo(@-5);
        }];
        
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1.0f);
        self.layer.shadowRadius = 2.0f;
        self.layer.shadowOpacity = 0.3f;
        self.layer.masksToBounds = NO;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.contentView.layer.cornerRadius].CGPath;
        /*UIView *bottomLineView = [[UIView alloc]init];
        bottomLineView.backgroundColor = [UIColor colorWithHexString:@"9ED8F2"];
        //bottomLineView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:bottomLineView];
        [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@2);
        }];*/
    }
    return self;
}



@end
