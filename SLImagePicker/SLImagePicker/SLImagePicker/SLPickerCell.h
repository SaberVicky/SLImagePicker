//
//  SLPickerCell.h
//  ssdfsdf
//
//  Created by songlong on 16/5/6.
//  Copyright © 2016年 songlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLPickerCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, copy) void (^selectBlock)(BOOL isSelected);

@end
