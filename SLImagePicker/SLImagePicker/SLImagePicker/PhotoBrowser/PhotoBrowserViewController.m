//
//  PhotoBrowserViewController.m
//  Weibo
//
//  Created by songlong on 15/11/25.
//  Copyright © 2015年 songlong. All rights reserved.
//

#import "PhotoBrowserViewController.h"
#import "PhotoBrowserViewCell.h"
#import "UIImage+SLExtension.h"
#import <AssetsLibrary/AssetsLibrary.h>

NSString *PhotoBrowserViewCellId = @"PhotoBrowserViewCellId";

@interface PhotoBrowserViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation PhotoBrowserViewController

- (instancetype)initWithElcAssets:(NSArray *)arrray IndexPath:(NSIndexPath *)indexPath {
    if (self = [super init]) {
        _navigationBarColor = [UIColor blueColor];
        _browserImageWidth = 600;
        self.elcAssets = arrray;
        self.currentIndexPath = indexPath;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ((floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)) {
        self.automaticallyAdjustsScrollViewInsets=NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.size.width += 20;
    self.view = [[UIView alloc] initWithFrame:rect];
    [self setupUI];
}

- (void)setupUI {
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = self.view.bounds.size;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.pagingEnabled = YES;
    _collectionView.bounces = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[PhotoBrowserViewCell class] forCellWithReuseIdentifier:PhotoBrowserViewCellId];
    [self.view addSubview:_collectionView];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
//    _topView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    _topView.backgroundColor = _navigationBarColor ;
    [self.view addSubview:_topView];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 26, 32, 32)];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"sl_arrow_back"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:cancelButton];
    
//    UIButton *topButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 44, 20, 44, 44)];
//    topButton.backgroundColor = [UIColor whiteColor];
//    [_topView addSubview:topButton];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 49, [UIScreen mainScreen].bounds.size.width, 49)];
//    _bottomView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    _bottomView.backgroundColor = _navigationBarColor;
    
    [self.view addSubview:_bottomView];
    
    [_collectionView scrollToItemAtIndexPath:_currentIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)clickCancelButton {
    [self.navigationController popViewControllerAnimated:YES];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elcAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoBrowserViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoBrowserViewCellId forIndexPath:indexPath];
    
    [cell setupUI];
    ALAsset *result = self.elcAssets[indexPath.item];
    CGImageRef ref = [[result  defaultRepresentation]fullScreenImage];
    
    UIImage *img = [[UIImage alloc]initWithCGImage:ref];
    UIImage *scaleImage = [img scaleToWidth:_browserImageWidth];
    cell.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [cell.imageView addGestureRecognizer:tap];
    cell.backgroundColor = [UIColor blackColor];
    cell.icon = scaleImage;
    return cell;
}

- (void)tap {
    _topView.hidden = !_topView.hidden;
    _bottomView.hidden = !_bottomView.hidden;
}




@end
