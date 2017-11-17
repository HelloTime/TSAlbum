//
//  TSPhotoViewController.m
//  demo
//
//  Created by Ken on 2017/6/19.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import "TSPhotoViewController.h"
#import "TSPreviewViewController.h"
#import "TSPhotoCollectionViewCell.h"
#import "TSPhotoCollectionReusableView.h"

#import "TSAlbumHelper.h"
#import "TSPhotoManager.h"

#define MARGIN 5

@interface TSPhotoViewController () <TSPhotoCollectionViewCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
// --底部工具条
@property (nonatomic, strong) UIToolbar *bar;
// --完成按钮
@property (nonatomic, strong) UIButton *doneButton;
// --预览按钮
@property (nonatomic, strong) UIButton *previewButton;
// --数量文本
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation TSPhotoViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)dealloc {
    [[TSPhotoManager sharedInstance].assets removeAllObjects];
}

- (instancetype)initWithPhotoContext:(TSPhotoContext *)photoContext {
    if (self = [super init]) {
        photoContext.photoSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 5 * MARGIN) / 4, ([UIScreen mainScreen].bounds.size.width - 5 * MARGIN) / 4);
        self.photoContext = photoContext;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.collectionView reloadData];
    self.doneButton.enabled = [TSPhotoManager sharedInstance].assets.count;
    self.countLabel.text = [NSString stringWithFormat:@"%d",(int)[TSPhotoManager sharedInstance].assets.count];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.photoContext.assetCollection.localizedTitle;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
    [self.view addSubview:self.collectionView];
    if (self.photoContext.assetResult.count > 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.photoContext.assetResult.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }
    [self setupBar];
}

- (void)dismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        TSPhotoCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([TSPhotoCollectionReusableView class]) forIndexPath:indexPath];
        view.photoCountLabel.text = [NSString stringWithFormat:@"共有%d张照片",(int)self.photoContext.assetResult.count];
        return view;
    }
    return nil;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoContext.assetResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TSPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.delegateViewController = self.navigationController;
    [[TSAlbumHelper sharedInstance] ts_cachingImageForAsset:[self.photoContext.assetResult objectAtIndex:indexPath.row]
                                                 targetSize:self.photoContext.photoSize
                                          completionHandler:^(UIImage *image, BOOL isImage, NSTimeInterval duration) {
                                              cell.imageView.image = image;
                                              cell.chooseButton.hidden = !isImage;
                                              cell.chooseButton.selected = [[TSPhotoManager sharedInstance].assets containsObject:[self.photoContext.assetResult objectAtIndex:indexPath.row]];
                                          }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TSPhotoContext *photoContext = [[TSPhotoContext alloc] init];
    photoContext.assetCollection = self.photoContext.assetCollection;
    photoContext.assetResult = self.photoContext.assetResult;
    photoContext.startingIndex = indexPath.row;
    TSPreviewViewController *controller = [TSPreviewViewController controllerWithPhotoContext:photoContext];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)ts_photoCollectionViewCell:(TSPhotoCollectionViewCell *)cell didCheck:(BOOL)isCheck {
    if (isCheck) {
        [[TSPhotoManager sharedInstance].assets addObject:[self.photoContext.assetResult objectAtIndex:[self.collectionView indexPathForCell:cell].row]];
    } else {
        [[TSPhotoManager sharedInstance].assets removeObject:[self.photoContext.assetResult objectAtIndex:[self.collectionView indexPathForCell:cell].row]];
    }
    
    self.doneButton.enabled = [TSPhotoManager sharedInstance].assets.count > 0;
    self.previewButton.enabled = [TSPhotoManager sharedInstance].assets.count > 0;
    
    self.countLabel.text = [NSString stringWithFormat:@"%d",(int)[TSPhotoManager sharedInstance].assets.count];
    [UIView animateWithDuration:0.2 animations:^{
        
        self.countLabel.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.countLabel.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            
        }];
        
    }];
}

- (void)done {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        // --发送图片
        [[TSPhotoManager sharedInstance] sendOriginalImages:NO];
    }];
}

- (void)preview {
    TSPhotoContext *photoContext = [[TSPhotoContext alloc] init];
    photoContext.assetCollection = self.photoContext.assetCollection;
    photoContext.assetResult = [TSPhotoManager sharedInstance].assets;
    photoContext.startingIndex = 0;
    TSPreviewViewController *controller = [TSPreviewViewController controllerWithPhotoContext:photoContext];
    [self.navigationController pushViewController:controller animated:YES];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = MARGIN;
        layout.minimumInteritemSpacing = MARGIN;
        layout.sectionInset = UIEdgeInsetsMake(MARGIN, MARGIN, MARGIN, MARGIN);
        layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 5 * MARGIN) / 4, ([UIScreen mainScreen].bounds.size.width - 5 * MARGIN) / 4);
        layout.footerReferenceSize = CGSizeMake(0, 44);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.alwaysBounceVertical = true;
        [_collectionView registerClass:[TSPhotoCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [_collectionView registerClass:[TSPhotoCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([TSPhotoCollectionReusableView class])];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    }
    return _collectionView;
}

- (void)setupBar {
    self.bar = [[UIToolbar alloc] init];
    [self.view addSubview:self.bar];
    
    self.previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.countLabel = [UILabel new];
    [self.bar addSubview:self.previewButton];
    [self.bar addSubview:self.countLabel];
    [self.bar addSubview:self.doneButton];
    
    self.previewButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.previewButton setTitle:@"预览" forState:UIControlStateNormal];
    [self.previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.previewButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    self.doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor colorWithRed:18/255.0 green:150/255.0 blue:219/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    self.doneButton.enabled = NO;
    self.previewButton.enabled = NO;
    
    self.countLabel.font = [UIFont systemFontOfSize:16];
    self.countLabel.backgroundColor = [UIColor colorWithRed:18/255.0 green:150/255.0 blue:219/255.0 alpha:1.0];
    self.countLabel.layer.cornerRadius = 12.5f;
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.text = @"0";
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [self.previewButton addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];
    
    self.bar.translatesAutoresizingMaskIntoConstraints = NO;
    self.previewButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.doneButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bar
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bar
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
    
    [self.bar addConstraint:[NSLayoutConstraint constraintWithItem:self.previewButton
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.bar
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0
                                                          constant:15]];
    
    [self.bar addConstraint:[NSLayoutConstraint constraintWithItem:self.previewButton
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.bar
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0]];
    
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
    
    [self.bar addConstraint:[NSLayoutConstraint constraintWithItem:self.countLabel
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.doneButton
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0
                                                          constant:-10]];
    
    [self.bar addConstraint:[NSLayoutConstraint constraintWithItem:self.countLabel
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.bar
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0]];
    
    [self.bar addConstraint:[NSLayoutConstraint constraintWithItem:self.countLabel
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0
                                                          constant:25]];
    
    [self.bar addConstraint:[NSLayoutConstraint constraintWithItem:self.countLabel
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0
                                                          constant:25]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
