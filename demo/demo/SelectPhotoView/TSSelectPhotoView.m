//
//  TSSelectPhotoView.m
//  demo
//
//  Created by Ken on 2017/6/22.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import "TSSelectPhotoView.h"
#import "TSPhotoCell.h"
#import "TSCameraHelper.h"
#import "TSAlbum.h"

#define PhotoMargin 10
#define PhotoItemWH (([UIScreen mainScreen].bounds.size.width - 5 * (PhotoMargin) ) / 4)

@interface TSSelectPhotoView () <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (nonatomic, strong) UICollectionView *collectionView;

@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;

@end

@implementation TSSelectPhotoView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configCollectionView];
        self.maxImageCount = 3;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)localPhoto
{
    __weak typeof(self)weakSelf = self;
    [TSCameraHelper checkPhotoLibraryAuthorizationStatus:^(BOOL granted) {
        if (granted) {
            [TSPhotoManager sharedInstance].imageCallBack = ^(NSArray<UIImage *> *images) {
                [weakSelf.images addObjectsFromArray:images];
                [weakSelf updateCollectionViewHeight];
                [weakSelf.collectionView reloadData];
            };
            [TSPhotoManager sharedInstance].imageDataCallBack = ^(NSArray<NSData *> *imageDatas) {
                
            };
            [TSPhotoManager sharedInstance].photoSize = CGSizeMake(PhotoItemWH, PhotoItemWH);
            [TSPhotoManager sharedInstance].maxPhotoCount = self.maxImageCount - self.images.count;
            [_delegateViewController presentViewController:[TSPhotoNavigationController new] animated:YES completion:nil];
        }
    }];
}

- (void)takePhoto
{
    [TSCameraHelper checkCameraAuthorizationStatus:^(BOOL granted) {
        //资源类型为照相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        
        //判断是否有相机
        if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置选择后的图片可被编辑
            picker.allowsEditing = NO;
            picker.sourceType = sourceType;
            [self.delegateViewController presentViewController:picker animated:YES completion:nil];
            
        }
        else
        {
            NSLog(@"该设备无摄像头");
        }
    }];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *pickerImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self saveImage:pickerImage];
    }
    [self.images addObject:pickerImage];
    [self updateCollectionViewHeight];
    [self.collectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}


- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    NSLog(@"message is %@",message);
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.images.count < _maxImageCount) {
        return self.images.count+1;
    } else {
        return self.images.count;
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TSPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CCPhotoCell" forIndexPath:indexPath];
    if (indexPath.row == self.images.count) {
        cell.imageView.image = [UIImage imageNamed:@"btn_addPicture_BgImage"];
    } else {
        cell.imageView.image = self.images[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.images.count) {
        if (self.images.count == self.maxImageCount) {
            return ;
        }
        [_delegateViewController setEditing:NO animated:YES];
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"照片选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self localPhoto];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePhoto];
        }]];
        
        [_delegateViewController presentViewController:alertController animated:YES completion:nil];
    }
}


- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(PhotoItemWH, PhotoItemWH);
    layout.minimumInteritemSpacing = PhotoMargin;
    layout.minimumLineSpacing = PhotoMargin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[TSPhotoCell class] forCellWithReuseIdentifier:@"CCPhotoCell"];
    [self addSubview:self.collectionView];
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0 constant:0]];
    
    [self addConstraint:self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.collectionView
                                                                             attribute:NSLayoutAttributeHeight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                                            multiplier:1.0 constant:((self.images.count)/4+1)*(PhotoItemWH+PhotoMargin)+PhotoMargin]];
}

- (UIViewController *)delegateViewController {
    NSAssert(_delegateViewController != nil, @"跳转的controller不能为nil");
    return _delegateViewController;
}

- (void)updateCollectionViewHeight {
    self.heightConstraint.constant = ((self.images.count)/4+1)*(PhotoItemWH+PhotoMargin)+PhotoMargin;
    [UIView animateWithDuration:.5 animations:^{
        [self layoutIfNeeded];
    }];
}

- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray arrayWithCapacity:0];
    }
    return _images;
}

- (void)setMaxImageCount:(NSInteger)maxImageCount {
    _maxImageCount = maxImageCount;
}

@end
