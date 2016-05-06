//
//  SLPickerViewController.m
//  ssdfsdf
//
//  Created by songlong on 16/5/5.
//  Copyright © 2016年 songlong. All rights reserved.
//

#import "SLPickerViewController.h"
#import "SLPickerCell.h"
#import "SLImageBrowserViewController.h"
#import "SLImagePickerViewController.h"

static NSString * const reuseIdentifier = @"pickerCell";

@interface SLPickerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *elcAssets;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *selectedImages;
@property (nonatomic, strong) NSMutableArray *sendImages;

@property (nonatomic, assign) NSInteger left;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) ReturnImageType returnImageType;

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

- (void)setupUI {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 5;
    NSInteger count = 4;
    CGFloat w = ([UIScreen mainScreen].bounds.size.width - (count + 1) * margin) / count;
    layout.itemSize = CGSizeMake(w, w);
    layout.sectionInset = UIEdgeInsetsMake(margin, margin, 0, margin);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[SLPickerCell class] forCellWithReuseIdentifier:reuseIdentifier];
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

- (void)send {
    
    [_sendImages removeAllObjects];
    
    for (int i = 0; i < _selectedImages.count; i++) {
        NSInteger count = [_selectedImages[i] integerValue];
        ALAsset *result = self.elcAssets[count];
        
        if (_returnImageType == TypeThumbnail) {
            CGImageRef ref = [result thumbnail];
            UIImage *img = [[UIImage alloc]initWithCGImage:ref];
            [_sendImages addObject:img];
        } else if (_returnImageType == TypeFullScreen) {
            CGImageRef ref = [[result  defaultRepresentation] fullScreenImage];
            UIImage *img = [[UIImage alloc]initWithCGImage:ref];
            [_sendImages addObject:img];
        } else {
            CGImageRef ref = [[result  defaultRepresentation] fullResolutionImage];
            UIImage *img = [[UIImage alloc]initWithCGImage:ref];
            [_sendImages addObject:img];
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
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SLImageBrowserViewController *vc = [[SLImageBrowserViewController alloc] init];
    vc.elcAssets = _elcAssets;
    vc.currentIndexPath = indexPath;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
