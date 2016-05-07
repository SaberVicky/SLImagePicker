//
//  PhotoBrowserViewCell.h
//  Weibo
//
//  Created by songlong on 15/11/25.
//  Copyright © 2015年 songlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoBrowserViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIImageView *imageView;

- (void)setupUI;
@end
