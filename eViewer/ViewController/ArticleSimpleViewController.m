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

const static NSInteger CELL_HEIGHT = 220;
//const static NSInteger CELL_WIDTH = [UIScreen mainScreen].bounds.size.width-10;


@interface ArticleSimpleViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

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
        collectionView.bounces = NO;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
