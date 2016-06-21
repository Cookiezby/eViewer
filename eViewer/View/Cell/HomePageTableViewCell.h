//
//  HomePageTableViewCell.h
//  eViewer
//
//  Created by cookie on 6/21/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageTableViewCell : UITableViewCell

@property (strong, nonatomic)UIImageView *coverImageView;
@property (strong, nonatomic)UILabel *titleLabel;

@property (strong, nonatomic)UILabel *authorLabel;
@property (strong, nonatomic)UILabel *postTimeLabel;

@end
