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

@interface PhotoGalleryViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation PhotoGalleryViewController

- (instancetype)init{
    self = [super init];
    if(self){
           }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _collectionView = ({
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH-10,100);
        layout.minimumLineSpacing = 10;
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
        [self.view addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        
        //CollectionView Setting
        
        collectionView.backgroundColor = TABLE_VIEW_BACKGROUND_COLOR;
        [collectionView registerClass:[ArticleSimpleCollectionViewCell class] forCellWithReuseIdentifier:@"ArticleSimpleCell"];
        collectionView.showsVerticalScrollIndicator = NO;
        //collectionView.bounces = NO;
        [self.view addSubview:collectionView];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView;
    });

    
    //self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewdataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ArticleSimpleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ArticleSimpleCell" forIndexPath:indexPath];
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
