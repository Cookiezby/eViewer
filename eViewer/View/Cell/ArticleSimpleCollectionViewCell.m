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
            label.textColor = [UIColor blueColor];
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

    }
    return self;
}



@end
