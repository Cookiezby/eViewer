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
            scrollView.maximumZoomScale = 2.0;
            [self.contentView addSubview:scrollView];
            [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
            scrollView;
            
        });
        
        
        
        _imageView = ({
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-SCREEN_WIDTH)/2 ,SCREEN_WIDTH,SCREEN_WIDTH)];
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [_scrollView addSubview:imageView];
            
            imageView;
        });
        
        
        
        
        //self.scrollView.contentSize = self.contentView.frame.size;
    }
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat originY = MAX(0,self.contentView.frame.size.height/2 - self.imageView.frame.size.height/2);
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, originY, self.imageView.frame.size.width, self.imageView.frame.size.height);
    DebugLog(@"x = %f y = %f width = %f height = %f",self.imageView.frame.origin.x,self.imageView.frame.origin.y,self.imageView.frame.size.width,self.imageView.frame.size.height);
}

- (void)swipe{
    
}




@end
