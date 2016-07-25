//
//  PhotoGalleryViewController.m
//  eViewer
//
//  Created by cookie on 7/16/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "PhotoGalleryViewController.h"
#import "Masonry.h"
#import "ArticleSimpleCollectionViewCell.h"
#import "PhotoCollectionViewCell.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "EVHTMLManager.h"
#import "ZPhotoReviewViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface PhotoGalleryViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) SDWebImageManager *manager;
@property (strong, nonatomic) NSMutableArray *thumbLinkList;
@property (strong, nonatomic) NSMutableArray *fullSizeImageLinkList;

@end

@implementation PhotoGalleryViewController

- (instancetype)init{
    self = [super init];
    if(self){
        _manager = [SDWebImageManager sharedManager];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _collectionView = ({
        
        CGFloat imageSize = (SCREEN_WIDTH-5)/4;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(imageSize,imageSize);
        //flow.minimumLineSpacing = 0;
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
        [self.view addSubview:collectionView];
        //CollectionView Setting
        collectionView.contentInset = UIEdgeInsetsMake(0, 1, 0, 1);
        collectionView.backgroundColor = TABLE_VIEW_BACKGROUND_COLOR;
        [collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCell"];
        collectionView.showsVerticalScrollIndicator = NO;
        //collectionView.bounces = NO;
        [self.view addSubview:collectionView];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView;
    });
    
    self.navigationItem.title = self.photoGallery.galleryTitle;
    
    
    
    EVHTMLManager *manager = [[EVHTMLManager alloc]init];
    
    
    [SVProgressHUD show];
    self.collectionView.userInteractionEnabled = NO;
    [manager getAllGalleryImage:self.photoGallery.galleryLink withCompleteHandler:^(NSMutableArray *thumbArray, NSMutableArray *fullSizeArray) {
        //self.photoAmount = thumbArray.count;
        self.thumbLinkList = thumbArray;
        self.fullSizeImageLinkList = fullSizeArray;
        [self.collectionView reloadData];
        self.collectionView.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
    }];
    
    //self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UICollectionViewDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DebugLog(@"try to presntation");
    ZPhotoReviewViewController *toView = [[ZPhotoReviewViewController alloc]init];
    toView.source = self.fullSizeImageLinkList;
    toView.selectedIndex = indexPath.item;
    [self presentViewController:toView animated:YES completion:nil];
}

#pragma mark - UICollectionViewdataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoGallery.photoAmount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:self.thumbLinkList[indexPath.item] placeholderImage:[UIImage imageNamed:@"PlaceHolderSquare.png"] options:0];
    
    return cell;
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
