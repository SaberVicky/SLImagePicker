
# SLImagePicker

## Overview

SLImagePicker是一个相册选择加图片浏览的框架，用法参见demo

## Usage


##### programmatically

```objective-c
SLImagePickerViewController *vc = [[SLImagePickerViewController alloc] initImagePicker];
    vc.pickerDelegate = self;
    vc.navigationBarColor = [UIColor orangeColor];
    [self presentViewController:vc animated:YES completion:nil];
    
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

//返回图片宽度像素,默认为600
@property (nonatomic, assign) CGFloat returnImageWidth;

//图片浏览器图片像素,默认为600
@property (nonatomic, assign) CGFloat browserImageWidth;    
```

##### delegate methods

```objective-c
//图片选择完成的回调，images为图片数组
- (void)imagePickerViewController:(SLImagePickerViewController *)picker didFinishPickingImages:(NSArray *)images;
```

## Licence

Circle menu is released under the MIT license.

