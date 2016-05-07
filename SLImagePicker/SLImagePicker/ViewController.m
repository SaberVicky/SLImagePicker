//
//  ViewController.m
//  SLImagePicker
//
//  Created by songlong on 16/5/6.
//  Copyright © 2016年 songlong. All rights reserved.
//

#import "ViewController.h"
#import "SLImagePickerViewController.h"

@interface ViewController ()<SLImagePickerViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"打开相册" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)clickButton {
    SLImagePickerViewController *vc = [[SLImagePickerViewController alloc] initImagePicker];
    vc.pickerDelegate = self;
    vc.navigationBarColor = [UIColor orangeColor];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)imagePickerViewController:(SLImagePickerViewController *)picker didFinishPickingImages:(NSArray *)images {
    NSLog(@"您选择了%zd张照片", images.count);
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:images.firstObject];
    iconView.frame = CGRectMake(20, 200, 200, 200);
    [self.view addSubview:iconView];
}

@end
