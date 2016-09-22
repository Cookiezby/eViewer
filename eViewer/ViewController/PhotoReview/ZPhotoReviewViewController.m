//
//  ZPhotoReviewViewController.m
//  eViewer
//
//  Created by cookie on 7/17/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "ZPhotoReviewViewController.h"
#import "Masonry.h"
#import "ZPresentationController.h"
#import "ZPresentationAnimator.h"
#import "ZPhotoCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SwipeUpInteractiveTransition.h"
#import "ProgressView.h"
#import <Photos/Photos.h>
#import "MBProgressHUD.h"

const CGFloat SWIPE_VELOCITY_THRESHOULD = 1.2f;

typedef void (^Complete)(void);

@interface ZPhotoReviewViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

//@property (strong, nonatomic)UIView *test;
//@property (strong, nonatomic)UIScrollView *imageScrollView;

@property (nonatomic)SOURCE_TYPE sourceType;
//@property (nonatomic)CGPoint startDragPositon;
//@property (strong, nonatomic)SwipeUpInteractiveTransition *interactiveTransition;
@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)UIButton *saveImageButton;
@property (strong, nonatomic)UIButton *closeViewButton;
@property (strong, nonatomic)NSMutableArray *progressArray;


@end

@implementation ZPhotoReviewViewController

- (instancetype)initWithType:(SOURCE_TYPE)type source:(NSMutableArray *)sourceArray{
    self = [self init];
    _sourceType = type;
    return self;
}

- (instancetype)init{
    self = [super init];
    if(self){
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
        //self.interactiveTransition = [[SwipeUpInteractiveTransition alloc]init];
        //[self.interactiveTransition wireToViewController:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
       self.collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT);
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.view addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        //collectionView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        collectionView.delegate = self;
        collectionView.dataSource = self;
        //collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[ZPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCell"];
        
        //NSIndexPath *indexPath = self.selectedIndexPath;
        
        
        DebugLog(@"review %ld",self.selectedIndex);
        collectionView;
    });
    
    
    self.closeViewButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"CloseImageViewButton.png"] forState:UIControlStateNormal];
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@40);
            make.height.equalTo(@40);
            make.bottom.equalTo(@-40);
            make.right.equalTo(@-40);
        }];
        [button addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    
    self.saveImageButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"SaveImageButton.png"] forState:UIControlStateNormal];
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@40);
            make.height.equalTo(@40);
            make.bottom.equalTo(@-40);
            make.left.equalTo(@40);
        }];
        [button addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
        button;
    
    });
    
    self.progressArray = [[NSMutableArray alloc]init];
    for(int i = 0; i < self.source.count; i++){
        [self.progressArray addObject:@(0)];
    }
    //DebugLog(@"hhhh %ld",self.source.count);
    DebugLog(@"hahah %ld",self.progressArray.count);

}

- (void)viewDidAppear:(BOOL)animated{
    //[self.collectionView setContentOffset:CGPointMake(self.selectedIndex * SCREEN_WIDTH, 0) animated:NO];
    //[self.view layoutIfNeeded];
   
}

- (void)viewDidLayoutSubviews{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismiss{
    DebugLog(@"dismiss");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitionDeletgate
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    ZPresentationController *presentationController = [[ZPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    return presentationController;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    ZPresentationAnimator *animator = [[ZPresentationAnimator alloc]initWithBool:NO];
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    ZPresentationAnimator *animator = [[ZPresentationAnimator alloc]initWithBool:YES];
    return animator;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    return nil;
}


#pragma mark - UICollectionViewDelegate



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.source.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    [cell resetCell];
    CGFloat progress = [(NSNumber *)self.progressArray[indexPath.item] floatValue];
    [cell updateProgress:progress];
    NSURL *url = [NSURL URLWithString:self.source[indexPath.item]];
    cell.imageView.image = nil;
    if([[SDWebImageManager sharedManager]diskImageExistsForURL:url]){
        cell.imageView.image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:url]];
        CGFloat height = cell.imageView.image.size.height / (cell.imageView.image.size.width / SCREEN_WIDTH);
        cell.imageView.frame = CGRectMake(0, (SCREEN_HEIGHT - height)/2, SCREEN_WIDTH, height);
        self.progressArray[indexPath.item] = @(1.0);
        //[cell updateProgress:1.0];
    }else{
        /*ProgressView *progressView = [[ProgressView alloc]initWithFrame:CGRectMake(0, 0, 200, 5)];
        [cell.imageView addSubview:progressView];
        [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.imageView);
            make.width.equalTo(@200);
            make.height.equalTo(@5);
        }];*/
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            CGFloat complete = (CGFloat)receivedSize/(CGFloat)expectedSize;
            self.progressArray[indexPath.item] = @(complete);
            if([self isCellVisibleatIndexPath:indexPath]){
                [cell updateProgress:complete];
            }else{
                [cell updateProgress:0];
            }
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            self.progressArray[indexPath.item] = @(1.0);
            if([self isCellVisibleatIndexPath:indexPath]){
                [cell updateProgress:1.0];
            }else{
                [cell updateProgress:0];
            }
            CGFloat height = image.size.height / (image.size.width / SCREEN_WIDTH);
            cell.imageView.frame = CGRectMake(0, (SCREEN_HEIGHT - height)/2, SCREEN_WIDTH, height);
            cell.imageView.image = image;
        }];
        
    }
    //cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
}


#pragma mark - ButtonEvent

- (void)closeView:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)saveImage:(id)sender{
    //[SVProgressHUD show];
    NSInteger index = self.collectionView.contentOffset.x / SCREEN_WIDTH;
    DebugLog(@"%ld",index);
    ZPhotoCollectionViewCell *cell = (ZPhotoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:cell animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CheckMark.png"]];
    hud.minSize = CGSizeMake(100, 100);
    hud.customView = imageView;
    [hud hideAnimated:YES afterDelay:1.5f];
    //ZPhotoCollectionViewCell *cell = (ZPhotoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:cell.imageView.image];
    } completionHandler:^(BOOL success, NSError *error) {
        //[SVProgressHUD dismiss];
        if (success) {
            
        }
        else {
            
        }
    }];
}


- (BOOL)isCellVisibleatIndexPath:(NSIndexPath*) indexPath{
    if(self.collectionView.contentOffset.x == indexPath.item * SCREEN_WIDTH){
        DebugLog(@"contentoffset %f",self.collectionView.contentOffset.x);
        DebugLog(@"%ld is visible", indexPath.item);
        return YES;
      
    }else{
        return NO;
    }
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
