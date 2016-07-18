//
//  ZPhotoCollectionViewCell.m
//  eViewer
//
//  Created by cookie on 7/18/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "ZPhotoCollectionViewCell.h"
#import "Masonry.h"
@interface ZPhotoCollectionViewCell()<UIScrollViewDelegate>

@property (strong, nonatomic)UIScrollView *scrollView;

@end

@implementation ZPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height)];
            scrollView.delegate = self;
            scrollView.minimumZoomScale = 1.0;
            scrollView.maximumZoomScale = 3.0;
            [self.contentView addSubview:scrollView];
            scrollView;
        });
        
        
        
        _imageView = ({
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_WIDTH)];
            imageView.userInteractionEnabled = YES;
            [_scrollView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(_scrollView);
                make.width.equalTo(@(SCREEN_WIDTH));
                make.height.equalTo(@(SCREEN_WIDTH));
            }];
            imageView;
        });
        
    }
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}


@end
