//
//  SLImagePickerViewController.h
//  edaixi_client_ios
//
//  Created by songlong on 16/5/5.
//  Copyright © 2016年 edaixi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLImagePickerViewController;

typedef enum {
    
    TypeThumbnail,//缩略图
    TypeFullScreen,//全屏图
    TypeFullResolution//高清图
    
}ReturnImageType;

@protocol SLImagePickerViewControllerDelegate <UINavigationControllerDelegate>

//图片选择完成的回调，images为图片数组
- (void)imagePickerViewController:(SLImagePickerViewController *)picker didFinishPickingImages:(NSArray *)images;

@end

@interface SLImagePickerViewController : UINavigationController

@property (nonatomic, weak) id<SLImagePickerViewControllerDelegate> pickerDelegate;


//设置已有图片数量,默认为0
@property (nonatomic, assign) NSInteger choosenImagesCount;

//设置照片最大数量,默认为10
@property (nonatomic, assign) NSInteger maxChoosenImagesCount;

//导航栏背景色,默认为蓝色
@property (nonatomic, strong) UIColor *navigationBarColor;

//导航栏文字颜色,默认为白色
@property (nonatomic, strong) UIColor *navigationBarTitleColor;

//返回图片质量,默认为全屏图质量
@property (nonatomic, assign) ReturnImageType returnImageType;

//是否显示数量为0的相册,默认为NO,不显示
@property (nonatomic, assign) BOOL showAlbumWithNoPhotos;

- (instancetype)initImagePicker;

@end
