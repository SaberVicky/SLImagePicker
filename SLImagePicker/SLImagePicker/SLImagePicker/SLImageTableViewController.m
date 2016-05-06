//
//  SLImageTableViewController.m
//  edaixi_client_ios
//
//  Created by songlong on 16/5/5.
//  Copyright © 2016年 edaixi. All rights reserved.
//

#import "SLImageTableViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "SLPickerViewController.h"

@interface SLImageTableViewController ()
@property (nonatomic, strong) NSMutableArray *assetGroups;
@property (nonatomic, strong) NSArray *mediaTypes;
@property (nonatomic, strong) ALAssetsLibrary *library;
@end

@implementation SLImageTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        _mediaTypes = @[(NSString *)kUTTypeImage];
        _assetGroups = [NSMutableArray array];
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
        self.library = assetLibrary;
    }
    return self;
}


- (void)test {
    dispatch_async(dispatch_get_main_queue(), ^{
        void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
            
            if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
                NSString *errorMessage = NSLocalizedString(@"无法访问相册.请在'设置->隐私->照片'设置为打开状态.", nil);
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Access Denied", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
                
            } else {
                NSString *errorMessage = [NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]];
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"相册访问失败.", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
            }
            
            [self.navigationItem setTitle:nil];
            NSLog(@"A problem occured %@", [error description]);
        };
        
        void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
        {
            if (!group) {
                return;
            }
            NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
            NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
            
            if (([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) || [sGroupPropertyName isEqualToString:@"相机胶卷"]) {
                [self.assetGroups insertObject:group atIndex:0];
            }
            else {
                [self.assetGroups addObject:group];
            }
            [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
            
        };
        
        [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
                                    usingBlock:assetGroupEnumerator
                                  failureBlock:assetGroupEnumberatorFailure];
        
    });
    
    
}

- (void)reloadTableView {
    [self.tableView reloadData];
    self.title = @"相册";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"读取中";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickCancel)];
    [self test];
}

- (void)clickCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _assetGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *resuseID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: resuseID];
    }
    ALAssetsGroup *g = (ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row];
    [g setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger gCount = [g numberOfAssets];
    
    
    if (gCount <= 0 && !_showAlbumWithNoPhotos) {
        [self.assetGroups removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",[g valueForProperty:ALAssetsGroupPropertyName], (long)gCount];
    UIImage* image = [UIImage imageWithCGImage:[g posterImage]];
    image = [self resize:image to:CGSizeMake(50, 50)];
    [cell.imageView setImage:image];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];


    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UIImage *)resize:(UIImage *)image to:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SLPickerViewController *vc = [[SLPickerViewController alloc] init];
    ALAssetsGroup *g = (ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row];
    [g setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSString *name = [g valueForProperty:ALAssetsGroupPropertyName];
    vc.title = name;
    vc.assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
