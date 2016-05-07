//
//  PhotoBrowserViewCell.m
//  Weibo
//
//  Created by songlong on 15/11/25.
//  Copyright © 2015年 songlong. All rights reserved.
//

#import "PhotoBrowserViewCell.h"

@interface PhotoBrowserViewCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation PhotoBrowserViewCell


- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    [self resetScrollView];
    self.imageView.image = icon;
    
    CGSize size = [self displaySizeWithImage:icon];
    
    self.imageView.frame = CGRectMake(0, 0, size.width, size.height);
    if (size.height > self.scrollView.bounds.size.height) {
        self.scrollView.contentSize = size;
    } else {
        self.imageView.center = self.scrollView.center;
    }
}

- (void)resetScrollView {
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.contentOffset = CGPointZero;
    self.scrollView.contentSize = CGSizeZero;
}

- (CGSize)displaySizeWithImage:(UIImage *)image {
    CGFloat w = self.scrollView.bounds.size.width;
    CGFloat h = image.size.height * w / image.size.width;
    return CGSizeMake(w, h);
}



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        

    
    }
    return self;
}

- (void)setupUI {
    
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    _scrollView =[[UIScrollView alloc] init];
    [self.contentView addSubview:self.scrollView];
    _imageView = [[UIImageView alloc] init];
    [self.scrollView addSubview:self.imageView];
    
    CGRect rect = self.bounds;
    rect.size.width -= 20;
    self.scrollView.frame = rect;
    
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 2.0;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.imageView;
}


@end
