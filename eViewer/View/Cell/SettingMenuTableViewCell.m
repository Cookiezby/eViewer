//
//  SettingMenuTableViewCell.m
//  eViewer
//
//  Created by cookie on 8/15/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "SettingMenuTableViewCell.h"
#import "Masonry.h"

@implementation SettingMenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        
        self.iconView = ({
            UIImageView *imageView = [[UIImageView alloc]init];
            //imageView.backgroundColor = [UIColor lightGrayColor];
            [self.contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                //make.right.equalTo(self.titleLabel.mas_left).with.offset(-20);
                make.left.equalTo(@10);
            }];
            imageView;
        });
        
        self.titleLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.textColor = [UIColor colorWithHexString:@"76C7ED"];
            label.font = [UIFont boldSystemFontOfSize:15];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                //make.centerX.equalTo(self.contentView);
                make.centerY.equalTo(self.contentView);
                //make.left.equalTo(@30);
                make.height.equalTo(@(self.contentView.frame.size.height));
                make.left.equalTo(self.iconView.mas_right).with.offset(5);
            }];
            label;
        });
        
        self.endLabel = ({
            UILabel *cachedSizeLabel = [[UILabel alloc]init];
            cachedSizeLabel.font = [UIFont systemFontOfSize:12];
            cachedSizeLabel.textColor = [UIColor lightGrayColor];
            [cachedSizeLabel sizeToFit];
            [self.contentView addSubview:cachedSizeLabel];
            [cachedSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(@-20);
            }];
            cachedSizeLabel;
        });

        
        
        
    }
    return self;
}


@end
