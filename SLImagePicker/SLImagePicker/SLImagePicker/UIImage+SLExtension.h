//
//  UIImage+SLExtension.h
//  ssdfsdf
//
//  Created by songlong on 16/5/6.
//  Copyright © 2016年 songlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SLExtension)
- (instancetype)scaleToWidth:(CGFloat)width;
+(UIImage *)imageWithColor:(UIColor *)aColor;
+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;

@end
