//
//  PhotoBrowserViewController.h
//  Weibo
//
//  Created by songlong on 15/11/25.
//  Copyright © 2015年 songlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoBrowserViewController : UIViewController

- (instancetype)initWithElcAssets:(NSArray *)arrray IndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) NSArray *elcAssets;

@end
