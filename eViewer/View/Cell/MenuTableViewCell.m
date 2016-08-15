//
//  MenuTableViewCell.m
//  eViewer
//
//  Created by cookie on 8/15/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "Masonry.h"

@implementation MenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.titleLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.textColor = [UIColor colorWithHexString:@"76C7ED"];
            label.font = [UIFont boldSystemFontOfSize:15];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.centerY.equalTo(self.contentView);
                //make.left.equalTo(@30);
                make.height.equalTo(@(self.contentView.frame.size.height));
            }];
            label;
        });
        
        self.iconView = ({
            UIImageView *imageView = [[UIImageView alloc]init];
            //imageView.backgroundColor = [UIColor lightGrayColor];
            [self.contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.titleLabel.mas_left).with.offset(-20);
            }];
            imageView;
        });

        
    }
    return self;
}


@end
