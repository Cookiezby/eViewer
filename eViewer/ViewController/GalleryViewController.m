//
//  GalleryViewController.m
//  eViewer
//
//  Created by cookie on 8/5/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "GalleryViewController.h"
#import "EVNaviViewController.h"
#import "EVHTMLManager.h"
#import "GallerySimpleCollectionViewCell.h"
#import "Masonry.h"
#import "GallerySimple.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PlanetView.h"
#import "DotGroupView.h"
#import "MBProgressHUD.h"
#import "GalleryDetail.h"
#import "PhotoGalleryViewController.h"

const static CGFloat CELL_HEIGHT = 200;
const static CGFloat PLANET_SIZE = 20;
const static CGFloat DOT_HEIGHT = 10;
const static CGFloat DOT_WIDTH = 40;
const static CGFloat REFRESH_HEIGHT = 50;
const static CGFloat PULL_DISTANCE = 100;

@interface GalleryViewController () <UICollectionViewDelegate, UICollectionViewDataSource>


@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *gallerySimpleList;
@property (strong, nonatomic) PlanetView *planetView;
@property (strong, nonatomic) DotGroupView *dotGroupView;

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"1EA2E0"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]bk_initWithImage:[UIImage imageNamed:@"MenuButton.png"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        DebugLog(@"showMenu");
        EVNaviViewController *naviViewController = (EVNaviViewController *)self.navigationController;
        [naviViewController showMenu];
    }];
    self.navigationItem.title = @"图集";
    //self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"EggIcon.png"]];
    // Do any additional setup after loading the view.
    
    self.collectionView = ({
        //CollectionViewLayout Setting
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH-10,CELL_HEIGHT);
        layout.minimumLineSpacing = 10;
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[GallerySimpleCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        collectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView;
    });
    
    
    self.gallerySimpleList = [[NSMutableArray alloc]init];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"获取图集中o(≧v≦)o", @"HUD message title");
    EVHTMLManager *manager = [[EVHTMLManager alloc]init];
    [manager getGalleryListPage:1 withCompleteHandler:^(NSMutableArray *list) {
        DebugLog(@"%ld",list.count);
        [hud hideAnimated:YES];
        [self.gallerySimpleList addObjectsFromArray:list];
        [self.collectionView reloadData];
    }];
    
    
    self.planetView = [[PlanetView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-PLANET_SIZE/2, -PLANET_SIZE-5, PLANET_SIZE, PLANET_SIZE)];
    [self.planetView pauseLayerAniamtion];
    [self.view addSubview:self.planetView];
    
    
    self.dotGroupView = [[DotGroupView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - DOT_WIDTH/2, SCREEN_HEIGHT - 64, DOT_WIDTH, DOT_HEIGHT) withDuration:2.0 dotColor:[UIColor lightGrayColor]];
    [self.dotGroupView pauseLayerAniamtion];
    [self.view addSubview:self.dotGroupView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GalleryDetail *galleryDetail = [[GalleryDetail alloc]init];
    GallerySimple *gallerySimple = (GallerySimple *)self.gallerySimpleList[indexPath.item];
    galleryDetail.galleryLink = gallerySimple.galleryLink;
    galleryDetail.galleryTitle = gallerySimple.galleryTitle;
    galleryDetail.photoAmount = gallerySimple.imageCount.intValue;
    DebugLog(@"%@",galleryDetail.galleryLink);
    PhotoGalleryViewController * photoGalleyViewController = [[PhotoGalleryViewController alloc]init];
    photoGalleyViewController.galleryDetail = galleryDetail;
    //[self presentViewController:test animated:YES completion:nil];
    [self.navigationController pushViewController:photoGalleyViewController animated:YES];

}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return section == 0 ? self.gallerySimpleList.count : 1;
    //return 6;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GallerySimpleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    GallerySimple *gallerySimple = (GallerySimple *)self.gallerySimpleList[indexPath.item];
    cell.titleLabel.text = gallerySimple.galleryTitle;
   
    cell.imageCountLabel.text = gallerySimple.imageCount;
    [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:gallerySimple.coverImageLink]];
    return cell;
}


#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y < 0){
        CGFloat originY = 0;
        if(scrollView.contentOffset.y > -PULL_DISTANCE/2){
            originY = -PLANET_SIZE-2 + (-scrollView.contentOffset.y/PULL_DISTANCE) * (PULL_DISTANCE/2 + PLANET_SIZE);
            CGRect planetFrame = CGRectMake(SCREEN_WIDTH/2 - PLANET_SIZE/2, originY , PLANET_SIZE, PLANET_SIZE);
            self.planetView.layer.transform = CATransform3DIdentity;
            self.planetView.frame = planetFrame;
        }else{
            originY = -PLANET_SIZE-2 + 0.5 * (PULL_DISTANCE/2 + PLANET_SIZE);
            CGFloat angle = (-scrollView.contentOffset.y-PULL_DISTANCE/2)/50*180;
            self.planetView.layer.transform = CATransform3DMakeRotation(angle/180 * M_PI, 0, 0, 1);
            self.planetView.layer.position = CGPointMake(SCREEN_WIDTH/2, originY + PLANET_SIZE/2);
        }
        
    }
    
    if(scrollView.contentOffset.y > 0){
        self.planetView.frame = CGRectMake(SCREEN_WIDTH/2 - PLANET_SIZE/2, -PLANET_SIZE - 2, PLANET_SIZE, PLANET_SIZE);
    }
    
    if(scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height){
        CGFloat originY = 0;
        CGFloat relativeDistance = (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height);
        if(relativeDistance < PULL_DISTANCE/2){
            originY = SCREEN_HEIGHT-64 - (relativeDistance/(PULL_DISTANCE)) * (PULL_DISTANCE/2 + DOT_HEIGHT);
            self.dotGroupView.layer.transform = CATransform3DIdentity;
            self.dotGroupView.frame = CGRectMake(SCREEN_WIDTH/2 - DOT_WIDTH/2, originY, DOT_WIDTH, DOT_HEIGHT);
        }else{
            originY = SCREEN_HEIGHT-64 - 0.5 * (PULL_DISTANCE/2 + DOT_HEIGHT);
            CGFloat scale = relativeDistance  /  (PULL_DISTANCE/2);
            //DebugLog(@"%f",scale);
            scale =  scale < 1.5 ? scale : 1.5;
            self.dotGroupView.layer.transform = CATransform3DMakeScale(scale, scale, 1);
            self.dotGroupView.layer.position = CGPointMake(SCREEN_WIDTH/2, originY + DOT_HEIGHT/2);
        }
        
    }
    
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    // DebugLog(@"%f",scrollView.contentOffset.y);
    if(scrollView.contentOffset.y < -(PULL_DISTANCE)){
        [self.planetView resumeLayerAnimation];
        self.collectionView.scrollEnabled = NO;
        [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [scrollView setContentOffset:CGPointMake(0,-(REFRESH_HEIGHT)) animated:NO];
        } completion:^(BOOL finished) {
            EVHTMLManager *manager = [[EVHTMLManager alloc]init];
            [manager getGalleryListPage:1  withCompleteHandler:^(NSMutableArray *array) {
                GallerySimple *newFirst = (GallerySimple *)array[0];
                GallerySimple *oldFirst = (GallerySimple *)self.gallerySimpleList[0];
                
                if ([newFirst.galleryTitle isEqualToString:oldFirst.galleryTitle]){
                    //doing nothing
                    // ProgressHUD 没有新内容哦
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = NSLocalizedString(@"没有新的内容哦:D", @"HUD message title");
                    [hud hideAnimated:YES afterDelay:1.0f];
                }else{
                    NSMutableArray *newArticle = [[NSMutableArray alloc]init];
                    [newArticle addObject:newFirst];
                    for(int i = 1; i < array.count; i++){
                        GallerySimple *simple = (GallerySimple *)array[i];
                        if(![simple.galleryTitle isEqualToString:oldFirst.galleryTitle]){
                            [newArticle addObject:simple];
                        }else{
                            break;
                        }
                    }
                    [newArticle addObjectsFromArray:self.gallerySimpleList];
                    self.gallerySimpleList = newArticle;
                    [self.collectionView reloadData];
                }
                [UIView animateWithDuration:0.3f animations:^{
                    self.planetView.frame = CGRectMake(SCREEN_WIDTH/2 - PLANET_SIZE/2, -PLANET_SIZE-5, PLANET_SIZE, PLANET_SIZE);
                    [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
                } completion:^(BOOL finished) {
                    [self.planetView pauseLayerAniamtion];
                    self.collectionView.scrollEnabled = YES;
                    //self.collectionView.contentInset = UIEdgeInsetsMake(64.0f, 0.0f, 0.0f, 0.0f);
                    //self.collectionView.bounces = YES;
                }];
            }];
            
        }];
        
        
    }else if(scrollView.contentOffset.y + scrollView.frame.size.height >= (scrollView.contentSize.height + PULL_DISTANCE)){
        DebugLog(@"more");
        NSInteger bottomContentOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        //CGPoint contentOffset = scrollView.contentOffset;
        //UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState;
        
        CGPoint finalContentOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height + REFRESH_HEIGHT);
        self.collectionView.scrollEnabled = NO;
        [self.dotGroupView resumeLayerAnimation];
        [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.collectionView.scrollEnabled = NO;
            [self.collectionView setContentOffset:finalContentOffset animated:NO];
        } completion:^(BOOL finished) {
            EVHTMLManager *manager = [[EVHTMLManager alloc]init];
            
            [manager getGalleryListPage:self.gallerySimpleList.count/12 + 1 withCompleteHandler:^(NSMutableArray *array) {
                //[self.articleSimpleList removeAllObjects];
                [self.gallerySimpleList addObjectsFromArray:array];
                [self.collectionView reloadData];
                self.collectionView.scrollEnabled = YES;
                [UIView animateWithDuration:0.3f animations:^{
                    [scrollView setContentOffset:CGPointMake(0, bottomContentOffset) animated:NO];
                    self.dotGroupView.frame = CGRectMake(SCREEN_WIDTH/2 - DOT_WIDTH/2, SCREEN_HEIGHT-64, DOT_WIDTH, DOT_HEIGHT);
                } completion:^(BOOL finished) {
                    [self.dotGroupView pauseLayerAniamtion];
                    self.collectionView.scrollEnabled = YES;
                }];
            }];
            
        }];
        
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
