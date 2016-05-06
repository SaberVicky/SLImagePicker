//
//  SLPickerCell.m
//  ssdfsdf
//
//  Created by songlong on 16/5/6.
//  Copyright © 2016年 songlong. All rights reserved.
//

#import "SLPickerCell.h"

@interface SLPickerCell()

@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation SLPickerCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _isSelected = NO;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _iconView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_iconView];
    
    CGFloat wh = self.contentView.bounds.size.width / 2;
//    self.contentView.bounds.size.width - 1.5 * wh
    _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wh, wh)];
    _selectButton.backgroundColor = _isSelected ? [UIColor redColor] : [UIColor whiteColor];
    [_selectButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectButton];
    
}

- (void)clickButton {
    _isSelected = !_isSelected;
    _selectButton.backgroundColor = _isSelected ? [UIColor redColor] : [UIColor whiteColor];
    
    self.selectBlock(_isSelected);
}

- (void)setIsSelected:(BOOL)isSelected {
    _selectButton.backgroundColor = isSelected ? [UIColor redColor] : [UIColor whiteColor];
}

@end
