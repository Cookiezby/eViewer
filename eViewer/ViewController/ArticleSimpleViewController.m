//
//  ArticleSimpleViewController.m
//  eViewer
//
//  Created by cookie on 6/30/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import "ArticleSimpleViewController.h"
#import "EVSideViewController.h"
#import "EVHTMLManager.h"
#import "ArticleSimple.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ArticleSimpleCollectionViewCell.h"
#import "ArticleDetailViewController.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
#import "PlanetView.h"
#import "DotGroupView.h"
#import <AFHTTPSessionManager.h>

#define HEIGHT self.view.frame.size.height + self.view.frame.origin.y

const static CGFloat CELL_HEIGHT = 220;
const static CGFloat REFRESH_HEIGHT = 50;
const static CGFloat PULL_DISTANCE = 100;
const static CGFloat PLANET_SIZE = 20;
const static CGFloat DOT_WIDTH = 40;
const static CGFloat DOT_HEIGHT = 10;
//const static NSInteger CELL_WIDTH = [UIScreen mainScreen].bounds.size.width-10;


@interface ArticleSimpleViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)NSMutableArray *articleSimpleList;
@property (strong, nonatomic)PlanetView *planetView;
@property (strong, nonatomic)DotGroupView *dotGroupView;
@property (strong, nonatomic)UIButton *scrollTopButton;

@end

@implementation ArticleSimpleViewController

- (void)viewDidLoad {
    
   
    
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"1EA2E0"];
        
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]bk_initWithImage:[UIImage imageNamed:@"MenuButton.png"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        DebugLog(@"showMenu");
        EVNaviViewController *naviViewController = (EVNaviViewController *)self.navigationController;
        [naviViewController showMenu];
    }];
    //self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NaviLogo.png"]];
    self.navigationItem.title = @"首页";
    self.articleSimpleList = [[NSMutableArray alloc]init];
    
    self.collectionView = ({
        //CollectionViewLayout Setting
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH-10,CELL_HEIGHT);
        layout.minimumLineSpacing = 10;
        //CollectionView Setting
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[ArticleSimpleCollectionViewCell class] forCellWithReuseIdentifier:@"ArticleSimpleCell"];
        collectionView.showsVerticalScrollIndicator = NO;
        //collectionView.bounces = NO;
        [self.view addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView;
    });
    
    self.planetView = [[PlanetView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-PLANET_SIZE/2, -PLANET_SIZE-5, PLANET_SIZE, PLANET_SIZE)];
    [self.planetView pauseLayerAniamtion];
    [self.view addSubview:self.planetView];
    
    
    self.dotGroupView = [[DotGroupView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - DOT_WIDTH/2, SCREEN_HEIGHT - 64, DOT_WIDTH, DOT_HEIGHT) withDuration:2.0 dotColor:[UIColor lightGrayColor]];
    [self.dotGroupView pauseLayerAniamtion];
    [self.view addSubview:self.dotGroupView];
    
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"获取新闻中o(≧v≦)o", @"HUD message title");

    EVHTMLManager *manager = [[EVHTMLManager alloc]init];
    [manager getPage:1 withHandler:^(NSMutableArray *array) {
        [self.articleSimpleList addObjectsFromArray:array];
        [hud hideAnimated:YES];
        [self.collectionView reloadData];
    }];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{
    //self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ArticleDetailViewController *detailViewController = [[ArticleDetailViewController alloc]init];
    ArticleSimple *articleSimple = self.articleSimpleList[indexPath.row];
    detailViewController.link = articleSimple.detailURL;
    [self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _articleSimpleList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ArticleSimpleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ArticleSimpleCell" forIndexPath:indexPath];
    
    ArticleSimple *articleSimple = self.articleSimpleList[indexPath.row];
    
    cell.authorLabel.text = articleSimple.author;
    cell.titleLabel.text = articleSimple.title;
    cell.postTimeLabel.text = articleSimple.postTime;
    
    if(articleSimple.coverImageURL.length != 0){
        [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:articleSimple.coverImageURL]
                               placeholderImage:[UIImage imageNamed:@"PlaceHolder.png"]];
    }else{
        cell.coverImageView.image = [UIImage imageNamed:@"EngadgetLogo.png"];
    }
   

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
            DebugLog(@"%f  %f",self.view.frame.origin.y,self.view.frame.size.height);
            originY = SCREEN_HEIGHT-64 - (relativeDistance/(PULL_DISTANCE)) * (PULL_DISTANCE/2 + DOT_HEIGHT);
            DebugLog(@"%f",originY);
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
            [manager getPage:1 withHandler:^(NSMutableArray *array) {
                ArticleSimple *newFirst = (ArticleSimple *)array[0];
                ArticleSimple *oldFirst = (ArticleSimple *)self.articleSimpleList[0];
                
                if ([newFirst.title isEqualToString:oldFirst.title]){
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
                        ArticleSimple *simple = (ArticleSimple *)array[i];
                        if(![simple.title isEqualToString:oldFirst.title]){
                            [newArticle addObject:simple];
                        }else{
                            break;
                        }
                    }
                    [newArticle addObjectsFromArray:self.articleSimpleList];
                    self.articleSimpleList = newArticle;
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
            
            [manager getPage:self.articleSimpleList.count/10+1 withHandler:^(NSMutableArray *array) {
                //[self.articleSimpleList removeAllObjects];
                [self.articleSimpleList addObjectsFromArray:array];
                [self.collectionView reloadData];
                self.collectionView.scrollEnabled = YES;
                [UIView animateWithDuration:0.3f animations:^{
                    [scrollView setContentOffset:CGPointMake(0, bottomContentOffset) animated:NO];
                    self.dotGroupView.frame = CGRectMake(SCREEN_WIDTH/2 - DOT_WIDTH/2,SCREEN_HEIGHT - 64, DOT_WIDTH, DOT_HEIGHT);
                } completion:^(BOOL finished) {
                    [self.dotGroupView pauseLayerAniamtion];
                    self.collectionView.scrollEnabled = YES;
                }];
            }];

        }];
        
    }

}
//用collectionview 的insertItem 来代替reload



/*(- (UIImageView *)cellBackGroundView{
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH-10, CELL_HEIGHT);
    UIGraphicsBeginImageContextWithOptions(rect.size, false, [UIScreen mainScreen].scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
}*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
