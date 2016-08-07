//
//  GallerySimpleCollectionViewCell.m
//  eViewer
//
//  Created by cookie on 8/7/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "GallerySimpleCollectionViewCell.h"
#import "Masonry.h"

@implementation GallerySimpleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
        self.coverImageView = ({
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:imageView];
            imageView.clipsToBounds = YES;
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@0);
                make.right.equalTo(@0);
                make.top.equalTo(@0);
                make.height.equalTo(@150);
            }];
            imageView;
        });
        
        self.titleLabel = ({
            UILabel * label = [[UILabel alloc]init];
            label.textColor = [UIColor darkGrayColor];
            label.font = [UIFont systemFontOfSize:12];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@10);
                make.bottom.equalTo(@-16);
            }];
            label;
        });
        
        UIImageView *imageCountView = ({
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ImageCountIcon.png"]];
            [self.contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@-16);
                make.right.equalTo(@-40);
            }];
            imageView;
        });
        
        
        self.imageCountLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.textColor = [UIColor darkGrayColor];
            label.font = [UIFont systemFontOfSize:10];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@-16);
                make.left.equalTo(imageCountView.mas_right).with.offset(10);
            }];
            label;
        });
        
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1.0f);
        self.layer.shadowRadius = 2.0f;
        self.layer.shadowOpacity = 0.3f;
        self.layer.masksToBounds = NO;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.contentView.layer.cornerRadius].CGPath;
        
        
    }
    return self;
}

@end
