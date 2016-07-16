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
#import <SVProgressHUD/SVProgressHUD.h>
#import "ArticleSimple.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ArticleSimpleCollectionViewCell.h"
#import "ArticleDetailViewController.h"

const static NSInteger CELL_HEIGHT = 220;
const static NSInteger REFRESH_HEIGHT = 50;
//const static NSInteger CELL_WIDTH = [UIScreen mainScreen].bounds.size.width-10;


@interface ArticleSimpleViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)NSMutableArray *articleSimpleList;

@end

@implementation ArticleSimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Engadget";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]bk_initWithTitle:@"Menu"
                                                                               style:UIBarButtonItemStylePlain
                                                                             handler:^(id sender) {
                                                                                 DebugLog(@"showMenu");
                                                                                 EVNaviViewController *naviViewController = (EVNaviViewController *)self.navigationController;
                                                                                 [naviViewController showMenu];
                                                                             }];
    
    self.articleSimpleList = [[NSMutableArray alloc]init];
    
    self.collectionView = ({
        //CollectionViewLayout Setting
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH-10,CELL_HEIGHT);
        layout.minimumLineSpacing = 10;
        //CollectionView Setting
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
        collectionView.backgroundColor = TABLE_VIEW_BACKGROUND_COLOR;
        [collectionView registerClass:[ArticleSimpleCollectionViewCell class] forCellWithReuseIdentifier:@"ArticleSimpleCell"];
        collectionView.showsVerticalScrollIndicator = NO;
        //collectionView.bounces = NO;
        [self.view addSubview:collectionView];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView;
    });
    

    EVHTMLManager *manager = [[EVHTMLManager alloc]init];
    [SVProgressHUD show];
    [manager getPage:1 withHandler:^(NSMutableArray *array) {
        [self.articleSimpleList addObjectsFromArray:array];
        [self.collectionView reloadData];
        [SVProgressHUD dismiss];
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ArticleDetailViewController *detailViewController = [[ArticleDetailViewController alloc]init];
    detailViewController.simpleArticle = self.articleSimpleList[indexPath.row];
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
    [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:articleSimple.coverImageURL]
                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

    return cell;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y < -150){
        
        //CGFloat refreshSpace = 50.0f;
        
        [UIView animateWithDuration:0.5f animations:^{
            //self.collectionView.contentInset = UIEdgeInsetsMake(114.0f, 0.0f, 0.0f, 0.0f);
            
            [scrollView setContentOffset:CGPointMake(0,-(64+REFRESH_HEIGHT)) animated:NO];
        } completion:^(BOOL finished) {
            //DebugLog(@"Refresh Complete");
            EVHTMLManager *manager = [[EVHTMLManager alloc]init];
            [SVProgressHUD show];
            [manager getPage:1 withHandler:^(NSMutableArray *array) {
                [self.articleSimpleList removeAllObjects];
                [self.articleSimpleList addObjectsFromArray:array];
                [self.collectionView reloadData];
                [SVProgressHUD dismiss];
                 
                [UIView animateWithDuration:0.5f animations:^{
                    [scrollView setContentOffset:CGPointMake(0, -64) animated:NO];
                } completion:^(BOOL finished) {
                    //self.collectionView.contentInset = UIEdgeInsetsMake(64.0f, 0.0f, 0.0f, 0.0f);
                    //self.collectionView.bounces = YES;
                }];
            }];
        }];
    }else if(scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height){
        DebugLog(@"more");
        NSLog(@"%f",scrollView.contentOffset.y);
        NSLog(@"%f",scrollView.frame.size.height);
        NSLog(@"%f",scrollView.contentSize.height);
        //CGPoint contentOffset = scrollView.contentOffset;
        //UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState;
        
        CGPoint finalContentOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height + REFRESH_HEIGHT);
        
        [UIView animateWithDuration:0.5f animations:^{
            self.collectionView.scrollEnabled = NO;
            [self.collectionView setContentOffset:finalContentOffset animated:NO];
        } completion:^(BOOL finished) {
            EVHTMLManager *manager = [[EVHTMLManager alloc]init];
            [SVProgressHUD show];
            [manager getPage:self.articleSimpleList.count/10+1 withHandler:^(NSMutableArray *array) {
                //[self.articleSimpleList removeAllObjects];
                [self.articleSimpleList addObjectsFromArray:array];
                [self.collectionView reloadData];
                [SVProgressHUD dismiss];
                self.collectionView.scrollEnabled = YES;
            }];
        }];
    }

}
//用collectionview 的insertItem 来代替reload

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}



- (void)setLoadingScrollViewInsets:(UIScrollView *)scrollView
{
    UIEdgeInsets loadingInset = scrollView.contentInset;
    loadingInset.top += self.view.frame.size.height;
    
    CGPoint contentOffset = scrollView.contentOffset;
    
    [UIView animateWithDuration:0.2 animations:^{
         scrollView.contentInset = loadingInset;
         scrollView.contentOffset = contentOffset;
     }];
}

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
