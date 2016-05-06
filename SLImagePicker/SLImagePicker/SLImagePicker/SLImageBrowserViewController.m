//
//  SLImageBrowserViewController.m
//  ssdfsdf
//
//  Created by songlong on 16/5/6.
//  Copyright © 2016年 songlong. All rights reserved.
//

#import "SLImageBrowserViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+SLExtension.h"

static NSString * const reuseIdentifier = @"browserCell";

@interface SLImageBrowserViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SLImageBrowserViewController

- (instancetype)init {
    if (self = [super init]) {
        _imagesArray = [NSArray array];
        _elcAssets = [NSArray array];
        _currentIndexPath = [[NSIndexPath alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [_collectionView scrollToItemAtIndexPath:_currentIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)setupUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.bounces = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.elcAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    ALAsset *result = self.elcAssets[indexPath.item];
    CGImageRef ref = [[result  defaultRepresentation]fullScreenImage];
    UIImage *img = [[UIImage alloc]initWithCGImage:ref];
    UIImage *scaleImage = [img scaleToWidth:600];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:scaleImage];
    iconView.frame = [UIScreen mainScreen].bounds;
    [cell.contentView addSubview:iconView];
    return cell;
}

@end
