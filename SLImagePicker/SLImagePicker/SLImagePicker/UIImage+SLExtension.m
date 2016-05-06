//
//  UIImage+SLExtension.m
//  ssdfsdf
//
//  Created by songlong on 16/5/6.
//  Copyright © 2016年 songlong. All rights reserved.
//

#import "UIImage+SLExtension.h"

@implementation UIImage (SLExtension)
- (instancetype)scaleToWidth:(CGFloat)width {
    
    if (width > self.size.width) {
        return self;
    }
    
    CGFloat height = self.size.height * width / self.size.width;
    CGRect rect = CGRectMake(0, 0, width, height);
    
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+(UIImage *)imageWithColor:(UIColor *)aColor{
    return [UIImage imageWithColor:aColor withFrame:CGRectMake(0, 0, 1, 1)];
}

+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame {
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, aFrame);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
