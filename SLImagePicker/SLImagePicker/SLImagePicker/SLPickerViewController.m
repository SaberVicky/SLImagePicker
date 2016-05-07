//
//  SLPickerViewController.m
//  ssdfsdf
//
//  Created by songlong on 16/5/5.
//  Copyright © 2016年 songlong. All rights reserved.
//

#import "SLPickerViewController.h"
#import "SLPickerCell.h"
#import "SLImagePickerViewController.h"
#import "PhotoBrowserViewController.h"
#import "UIImage+SLExtension.h"

static NSString * const reuseIdentifier = @"pickerCell";

@interface SLPickerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *elcAssets;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *selectedImages;
@property (nonatomic, strong) NSMutableArray *sendImages;

@property (nonatomic, assign) NSInteger left;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) ReturnImageType returnImageType;

@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *previewButton;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation SLPickerViewController

- (instancetype)init {
    if (self = [super init]) {
        self.elcAssets = [NSMutableArray array];
        _assetGroup = [[ALAssetsGroup alloc] init];
        _selectedImages = [NSMutableArray array];
        _sendImages = [NSMutableArray array];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self enumerateAssets];
    
    SLImagePickerViewController *vc = (SLImagePickerViewController *)self.navigationController;
    _left = vc.maxChoosenImagesCount - vc.choosenImagesCount;
    _maxCount = vc.maxChoosenImagesCount;
    _returnImageType = vc.returnImageType;
}

#pragma mark --- Private Method

- (void)dismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupUI {
    

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 5;
    NSInteger count = 4;
    CGFloat w = ([UIScreen mainScreen].bounds.size.width - (count + 1) * margin) / count;
    layout.itemSize = CGSizeMake(w, w);
    layout.sectionInset = UIEdgeInsetsMake(margin, margin, 0, margin);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 49 - 64) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[SLPickerCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    SLImagePickerViewController *naVc = (SLImagePickerViewController *)self.navigationController;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 49 - 64, [UIScreen mainScreen].bounds.size.width, 49)];
    bottomView.backgroundColor = naVc.navigationBarColor;
    [self.view addSubview:bottomView];
    
    _sendButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50 - 10, 7, 50, 35)];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_sendButton setTitleColor:[[UIColor alloc] initWithRed:218 / 25.0 green:247 / 255.0 blue:156 / 255.0 alpha:1] forState:UIControlStateDisabled];
    [_sendButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    _sendButton.enabled = NO;
    [bottomView addSubview:_sendButton];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50 - 10 - 22, 12.5, 24, 24)];
    _countLabel.backgroundColor = [UIColor greenColor];
    _countLabel.text = @"0";
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.layer.cornerRadius = 12;
    _countLabel.clipsToBounds = YES;
    _countLabel.hidden = YES;
    [bottomView addSubview:_countLabel];
    
    _previewButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 7, 50, 35)];
    [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
    [_previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_previewButton addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];
    _previewButton.enabled = NO;
    [bottomView addSubview:_previewButton];
}

- (void)enumerateAssets {
    __weak typeof(self) weakself = self;
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result == nil) {
            return;
        }
        
        [weakself.elcAssets addObject:result];
        [weakself.collectionView reloadData];
    }];
}

- (void)preview {
//    NSComparator cmptr = ^(id obj1, id obj2){
//        if ([obj1 integerValue] > [obj2 integerValue]) {
//            return (NSComparisonResult)NSOrderedDescending;
//        }
//        
//        if ([obj1 integerValue] < [obj2 integerValue]) {
//            return (NSComparisonResult)NSOrderedAscending;
//        }
//        return (NSComparisonResult)NSOrderedSame;
//    };
//    NSArray *sortedArray = [_selectedImages sortedArrayUsingComparator:cmptr];
    NSMutableArray *newArr = [NSMutableArray array];
    for (NSNumber *num in _selectedImages) {
        [newArr addObject:_elcAssets[num.integerValue]];
    }
    PhotoBrowserViewController *vc = [[PhotoBrowserViewController alloc] initWithElcAssets:newArr IndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    SLImagePickerViewController *naVc = (SLImagePickerViewController *)self.navigationController;
    vc.navigationBarColor = naVc.navigationBarColor;
    vc.browserImageWidth = naVc.browserImageWidth;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)send {
    
    CGFloat imageWith = ((SLImagePickerViewController *)self.navigationController).returnImageWidth;
    
    [_sendImages removeAllObjects];
    
    for (int i = 0; i < _selectedImages.count; i++) {
        NSInteger count = [_selectedImages[i] integerValue];
        ALAsset *result = self.elcAssets[count];
        
        if (_returnImageType == TypeThumbnail) {
            CGImageRef ref = [result thumbnail];
            UIImage *img = [[UIImage alloc]initWithCGImage:ref];
            UIImage *scaleImage = [img scaleToWidth:imageWith];
            [_sendImages addObject:scaleImage];
        } else if (_returnImageType == TypeFullScreen) {
            CGImageRef ref = [[result  defaultRepresentation] fullScreenImage];
            UIImage *img = [[UIImage alloc]initWithCGImage:ref];
            UIImage *scaleImage = [img scaleToWidth:imageWith];
            [_sendImages addObject:scaleImage];
        } else {
            CGImageRef ref = [[result  defaultRepresentation] fullResolutionImage];
            UIImage *img = [[UIImage alloc]initWithCGImage:ref];
            UIImage *scaleImage = [img scaleToWidth:imageWith];
            [_sendImages addObject:scaleImage];
        }
    }
    
    if (_sendImages.count == 0) {
        NSString *errorMessage = [NSString stringWithFormat:@"您还能再选%zd张照片", _left];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"错误", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kSendNotification" object:_sendImages];
    
    
}

#pragma mark --- UICollectionView Delegate / DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.elcAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakself = self;
    
    
    __weak SLPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    cell.isSelected = [self.selectedImages containsObject:@(indexPath.item)];
  
    
    ALAsset *result = self.elcAssets[indexPath.item];
    cell.iconView.image = [UIImage imageWithCGImage:result.thumbnail];
    
    cell.selectBlock = ^(BOOL isSelected){
        if (isSelected) {
            
            if (weakself.selectedImages.count == weakself.left) {
                NSString *errorMessage = [NSString stringWithFormat:@"您最多能选%zd张照片", weakself.maxCount];
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"错误", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
                cell.isSelected = NO;
            } else {
                [weakself.selectedImages addObject:@(indexPath.item)];
            }
            
        } else {
            [weakself.selectedImages removeObject:@(indexPath.item)];
        }
        
        weakself.sendButton.enabled = weakself.selectedImages.count > 0;
        weakself.previewButton.enabled = weakself.selectedImages.count > 0;
        weakself.countLabel.hidden = weakself.selectedImages.count <= 0;
        weakself.countLabel.text = [NSString stringWithFormat:@"%zd", weakself.selectedImages.count];
        CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scale.fromValue = @0.0;
        scale.toValue = @1.2;
        scale.duration = 0.25;
        scale.removedOnCompletion = YES;
        [weakself.countLabel.layer addAnimation:scale forKey:nil];
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    PhotoBrowserViewController *vc = [[PhotoBrowserViewController alloc] initWithElcAssets:_elcAssets IndexPath:indexPath];

    SLImagePickerViewController *naVc = (SLImagePickerViewController *)self.navigationController;
    vc.navigationBarColor = naVc.navigationBarColor;
    vc.browserImageWidth = naVc.browserImageWidth;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}



@end
