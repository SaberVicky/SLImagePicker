//
//  SLPickerButton.m
//  edaixi_client_ios
//
//  Created by songlong on 16/5/7.
//  Copyright © 2016年 edaixi. All rights reserved.
//

#import "SLPickerButton.h"

@interface SLPickerButton()

@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation SLPickerButton


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _isSelected = NO;
        CGFloat w = frame.size.width / 2;
        CGFloat h = frame.size.height / 2;
        CGFloat x = frame.size.width / 4;
        CGFloat y = frame.size.width / 4;
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _iconView.image = [UIImage imageNamed:@"waitingUnselected"];
        [self addSubview:_iconView];
    }
    return self;
}


- (void)setIsSelected:(BOOL)isSelected {
    if ((isSelected != _isSelected) && isSelected) {
        CABasicAnimation *cartAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        cartAnim.duration = 0.15;
        cartAnim.fromValue = @1.0;
        cartAnim.toValue = @1.3;
        cartAnim.repeatCount = 1;
        cartAnim.autoreverses = YES;
        [_iconView.layer addAnimation:cartAnim forKey:nil];
       
    }
    _isSelected = isSelected;
    _iconView.image = _isSelected ? [UIImage imageNamed:@"waitingOrderSelected"] : [UIImage imageNamed:@"waitingUnselected"];
}



@end
