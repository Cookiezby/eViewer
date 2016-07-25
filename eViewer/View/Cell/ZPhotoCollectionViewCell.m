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
        self.contentView.backgroundColor = [UIColor clearColor];
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height)];
            scrollView.delegate = self;
            scrollView.minimumZoomScale = 1.0;
            scrollView.maximumZoomScale = 2.0;
            //scrollView.bounces = NO;
            //[scrollView setZoomScale:1.0 animated:NO];
            [self.contentView addSubview:scrollView];
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.showsHorizontalScrollIndicator = NO;
            [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView);
                make.bottom.equalTo(self.contentView);
                make.left.equalTo(@0);
                make.right.equalTo(@0);
            }];
            scrollView.backgroundColor = [UIColor whiteColor];
            scrollView.userInteractionEnabled = YES;
            scrollView;
        });
        
        
        
        _imageView = ({
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 ,frame.size.width,frame.size.height)];
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [_scrollView addSubview:imageView];
            
            UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDouleTap:)];
            [doubleTap setNumberOfTapsRequired:2];
            [imageView addGestureRecognizer:doubleTap];
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
            [singleTap setNumberOfTapsRequired:1];
            [imageView addGestureRecognizer:singleTap];
            [singleTap requireGestureRecognizerToFail:doubleTap];
            
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
    //DebugLog(@"x = %f y = %f width = %f height = %f",self.imageView.frame.origin.x,self.imageView.frame.origin.y,self.imageView.frame.size.width,self.imageView.frame.size.height);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    DebugLog(@"%f",scale);
    if(scale <= 1){
        self.scrollView.scrollEnabled = NO;
        [self setCollectionViewScrollEnable:YES];
    }else{
        self.scrollView.scrollEnabled = YES;
        [self setCollectionViewScrollEnable:NO];
    }
}

- (void)setCollectionViewScrollEnable:(BOOL)enable{
    UICollectionView *collectionView = nil;
    UIView *view = self.contentView;
    while(view!=nil){
        if([view isKindOfClass:[UICollectionView class]]) {
            collectionView = (UICollectionView *)view;
            collectionView.pagingEnabled = enable;
            collectionView.scrollEnabled = enable;
            break;
        }
        view = [view superview];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer{
    DebugLog(@"single tap");
    
    UICollectionView *collectionView = (UICollectionView *)self.superview;
    UIViewController *viewController = (UIViewController *)collectionView.delegate;
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleDouleTap:(UITapGestureRecognizer *)recognizer{
    DebugLog(@"double tap");
    
    if(self.scrollView.zoomScale == self.scrollView.minimumZoomScale){
        //双击放大
        CGRect zoomRect = [self zoomRectForScale:self.scrollView.maximumZoomScale withCenter:[recognizer locationInView:recognizer.view]];
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }else{
        //双击恢复到原始大小
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
    
    
}

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center{
    CGRect zoomRect;
    
    zoomRect.size.height = _imageView.frame.size.height/scale;
    zoomRect.size.width = _imageView.frame.size.width/scale;
    
    zoomRect.origin.x = center.x - zoomRect.size.width/2;
    zoomRect.origin.y = center.y - zoomRect.size.height/2;
    
    return zoomRect;
}

- (void)resetCell{
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}


@end
