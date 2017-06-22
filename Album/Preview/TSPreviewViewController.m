//
//  TSPreviewViewController.m
//  demo
//
//  Created by Ken on 2017/6/20.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import "TSPreviewViewController.h"
#import "TSPreviewCollectionViewCell.h"
#import "TSPhotoManager.h"

@interface TSPreviewViewController () <TSPreviewCollectionViewCellDelegate>
// 右边选择按钮
@property (nonatomic, weak) UIButton *rightItem;
// 完成按钮
@property (nonatomic, strong) UIButton *doneButton;
// 底部工具条
@property (nonatomic, strong) UIToolbar *bar;
// 工具条底部约束，用来实现动画的
@property (nonatomic, strong) NSLayoutConstraint *barBottomConstraint;
@end

@implementation TSPreviewViewController

static NSString * const reuseIdentifier = @"Cell";

+ (instancetype)controllerWithPhotoContext:(TSPhotoContext *)photoContext {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    TSPreviewViewController *controller = [[TSPreviewViewController alloc] initWithCollectionViewLayout:layout];
    controller.photoContext = photoContext;
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavigationItem];
    [self setupCollectionViewLayout];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
// 完成
- (void)done {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        // --发送图片
        [[TSPhotoManager sharedInstance] sendOriginalImages:NO];
    }];
}
// 选中按钮点击事件
- (void)chooseImage {
    if ([TSPhotoManager sharedInstance].maxPhotoCount == [TSPhotoManager sharedInstance].assets.count && !self.rightItem.isSelected) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"最多只能选择%d张图",(int)[TSPhotoManager sharedInstance].assets.count] message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
        return;
    }
    // --找到当前显示的cell
    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] objectAtIndex:0];
    self.rightItem.selected = !self.rightItem.isSelected;
    
    if (self.rightItem.isSelected) {
        [[TSPhotoManager sharedInstance].assets addObject:[self.photoContext.assetResult objectAtIndex:indexPath.row]];
    } else {
        [[TSPhotoManager sharedInstance].assets removeObject:[self.photoContext.assetResult objectAtIndex:indexPath.row]];
    }
    [self.doneButton setTitle:[NSString stringWithFormat:@"完成(%d)",(int)[TSPhotoManager sharedInstance].assets.count] forState:UIControlStateNormal];
    self.doneButton.enabled = [TSPhotoManager sharedInstance].assets.count;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoContext.assetResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TSPreviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    PHAsset *asset = [self.photoContext.assetResult objectAtIndex:indexPath.row];
    [[TSAlbumHelper sharedInstance] ts_cachingImageForAsset:asset
                                                 targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight)
                                          completionHandler:^(UIImage *image, BOOL isImage, NSTimeInterval duration) {
                                              cell.imageView.image = image;
                                          }];
    cell.delegate = self;
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // --找到当前显示的cell
    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] objectAtIndex:0];
    // --显示当前图片是否选中
    self.rightItem.selected = [[TSPhotoManager sharedInstance].assets containsObject:[self.photoContext.assetResult objectAtIndex:indexPath.row]];
}


#pragma mark - TSPreviewCollectionViewCellDelegate
- (void)ts_previewCollectionViewCellDidClick:(TSPreviewCollectionViewCell *)cell {
    self.barBottomConstraint.constant = self.navigationController.navigationBar.isHidden ? 0 : 44;
    [UIView animateWithDuration:.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBar.isHidden animated:YES];
}


// 设置导航栏
- (void)setupNavigationItem {
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(0, 0, 36, 36);
    [rightItem setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [rightItem setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
    [rightItem addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    self.rightItem = rightItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    
    self.bar = [[UIToolbar alloc] init];
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.doneButton setTitle:[NSString stringWithFormat:@"完成(%d)",(int)[TSPhotoManager sharedInstance].assets.count] forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor colorWithRed:18/255.0 green:150/255.0 blue:219/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    self.doneButton.enabled = [TSPhotoManager sharedInstance].assets.count;
    
    [self.view addSubview:self.bar];
    [self.bar addSubview:self.doneButton];
    
    self.bar.translatesAutoresizingMaskIntoConstraints = NO;
    self.doneButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bar
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:self.barBottomConstraint = [NSLayoutConstraint constraintWithItem:self.bar
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self.view
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                    multiplier:1.0
                                                                                      constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bar
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bar
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:44]];
    
    [self.bar addConstraint:[NSLayoutConstraint constraintWithItem:self.doneButton
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.bar
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0
                                                          constant:-15]];
    
    [self.bar addConstraint:[NSLayoutConstraint constraintWithItem:self.doneButton
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.bar
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0]];
}
// 设置collectionView
- (void)setupCollectionViewLayout {
    self.collectionView.pagingEnabled = YES;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    // Register cell classes
    [self.collectionView registerClass:[TSPreviewCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    CGFloat margin = 20;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.photoContext.photoSize = layout.itemSize;
    
    CGRect rect = self.collectionView.frame;
    rect.size.width += margin;
    self.collectionView.frame = rect;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, margin);
    // --移动到点击的图片位置
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.photoContext.startingIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    self.rightItem.selected = [[TSPhotoManager sharedInstance].assets containsObject:[self.photoContext.assetResult objectAtIndex:self.photoContext.startingIndex]];
    self.doneButton.enabled = [TSPhotoManager sharedInstance].assets.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
