//
//  SLImagePickerViewController.m
//  edaixi_client_ios
//
//  Created by songlong on 16/5/5.
//  Copyright © 2016年 edaixi. All rights reserved.
//

#import "SLImagePickerViewController.h"
#import "SLImageTableViewController.h"
#import "UIImage+SLExtension.h"

@interface SLImagePickerViewController ()


@end

@implementation SLImagePickerViewController


- (void)initParameters {
    _choosenImagesCount = 0;
    _maxChoosenImagesCount = 10;
    _navigationBarColor = [UIColor blueColor];
    _navigationBarTitleColor = [UIColor whiteColor];
    _returnImageType = TypeFullScreen;
    _showAlbumWithNoPhotos = NO;
}

- (instancetype)initImagePicker {
    
    SLImageTableViewController *vc = [[SLImageTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self = [super initWithRootViewController:vc];
    
    if (self) {
        [self initParameters];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SLImageTableViewController *vc = (SLImageTableViewController *)self.topViewController;
    vc.showAlbumWithNoPhotos = _showAlbumWithNoPhotos;
    
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:_navigationBarColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_navigationBarTitleColor,UITextAttributeTextColor,nil]];
    [self.navigationBar setTintColor:_navigationBarTitleColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakself = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:@"kSendNotification" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSArray *imagesArray = note.object;
        
        if ([weakself.pickerDelegate respondsToSelector:@selector(imagePickerViewController:didFinishPickingImages:)]) {
            [weakself dismissViewControllerAnimated:YES completion:nil];
            [weakself.pickerDelegate imagePickerViewController:weakself didFinishPickingImages:imagesArray];
        }
    }];
}



- (void)dealloc {
//    kDebugLog(@"我释放了，啦啦啦啦");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kSendNotification" object:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
