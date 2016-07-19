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

const CGFloat SWIPE_VELOCITY_THRESHOULD = 1.2f;

@interface ZPhotoReviewViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (strong, nonatomic)UIView *test;
//@property (strong, nonatomic)UIScrollView *imageScrollView;
@property (strong, nonatomic)UICollectionView *collectionView;
@property (nonatomic)SOURCE_TYPE sourceType;
@property (strong, nonatomic)NSMutableArray *source;
@property (nonatomic)CGPoint startDragPositon;

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
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.test = ({
        UIView *view = [[UIView alloc]init];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@50);
            make.left.equalTo(@50);
            make.width.equalTo(@100);
            make.height.equalTo(@100);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(dismiss)];
        [self.view addGestureRecognizer:tap];
        
        view.backgroundColor = [UIColor blackColor];
        view;
    });
    
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
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.pagingEnabled = YES;
        [collectionView registerClass:[ZPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCell"];
        collectionView;
    });

    // Do any additional setup after loading the view.
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
    return 1;
}

/*- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    ZPhotoCollectionViewCell *customCell = (ZPhotoCollectionViewCell *)cell;
    [customCell recoverZoom];
}*/

#pragma mark - UIScrollViewDelegate

/*- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.startDragPositon = scrollView.contentOffset;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self adjustScrollView:scrollView];
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self adjustScrollView:scrollView];
    //self.isSwipe = false;
}*/

/*- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if(velocity.x > 1.5){
        DebugLog(@"right");
        CGPoint temp = CGPointMake(self.startDragPositon.x + SCREEN_WIDTH, self.startDragPositon.y);
        //CGPoint* point = &temp;
        //[scrollView setContentOffset:temp animated:YES]
        targetContentOffset->x = temp.x;
    }else if(velocity.x < -SWIPE_VELOCITY_THRESHOULD){
        
    }
}*/


- (void)adjustScrollView:(UIScrollView *)scrollView{
    CGFloat currentContentOffsetX = scrollView.contentOffset.x;
    //DebugLog(@"%f",currentContentOffsetX);
    
    NSInteger remain = (int)currentContentOffsetX % (int)SCREEN_WIDTH;
    NSInteger a = (int)currentContentOffsetX / (int)SCREEN_WIDTH;
    if(remain > SCREEN_WIDTH/2){
        CGFloat contentOffsetX = (a + 1) * SCREEN_WIDTH;
        if(contentOffsetX > (scrollView.contentSize.width-SCREEN_WIDTH)){
            contentOffsetX = scrollView.contentSize.width - SCREEN_WIDTH;
        }
        [scrollView setContentOffset:CGPointMake(contentOffsetX, scrollView.contentOffset.y) animated:YES];
        //DebugLog(@"%f",contentOffsetX);
    }else{
        CGFloat contentOffsetX = a * SCREEN_WIDTH;
        [scrollView setContentOffset:CGPointMake(contentOffsetX, scrollView.contentOffset.y) animated:YES];
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"PlaceHolderSquare.png"];
    //cell.backgroundColor = [UIColor lightGrayColor];
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
