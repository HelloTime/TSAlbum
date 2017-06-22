//
//  TSAlbumHelper.m
//  demo
//
//  Created by Ken on 2017/6/19.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import "TSAlbumHelper.h"


@interface TSAlbumHelper ()

@property (strong, nonatomic) PHPhotoLibrary *library;

@end

@implementation TSAlbumHelper {
    
}

static TSAlbumHelper  * _singleton = nil;

+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[TSAlbumHelper alloc] init];
        _singleton.library = [PHPhotoLibrary sharedPhotoLibrary];
    });
    return _singleton;
}

- (void)ts_loadAlbumGroupCompletionHandler:(void(^)(NSArray <PHAssetCollection *>*))handler {
    __weak typeof(self)weakSelf = self;
    NSMutableArray <PHAssetCollection *>*groups = [NSMutableArray arrayWithCapacity:0];
    
    [self ts_fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                subtype:PHAssetCollectionSubtypeAlbumRegular
                                options:nil
                      completionHandler:^(NSArray<PHAssetCollection *> *smartGroup) {
                          
                          [groups addObjectsFromArray:smartGroup];
                          
                          [weakSelf ts_fetchTopLevelUserCollectionsCompletionHandler:^(NSArray<PHAssetCollection *> *userGroup) {
                              [groups addObjectsFromArray:userGroup];
                              handler([NSArray arrayWithArray:groups]);
                          }];
    }];
}

- (void)ts_fetchTopLevelUserCollectionsCompletionHandler:(void(^)(NSArray <PHAssetCollection *>*))handler {
    [self ts_fetchAssetCollectionsTransToArray:[PHCollection fetchTopLevelUserCollectionsWithOptions:[[PHFetchOptions alloc] init]] completionHandler:handler];
}

- (void)ts_fetchAssetCollectionsWithType:(PHAssetCollectionType)type
                              subtype:(PHAssetCollectionSubtype)subtype
                              options:(PHFetchOptions *)options
                    completionHandler:(void(^)(NSArray <PHAssetCollection *>*))handler
{
    [self ts_fetchAssetCollectionsTransToArray:[PHAssetCollection fetchAssetCollectionsWithType:type
                                                                                  subtype:subtype
                                                                                  options:options]
                       completionHandler:handler];
}

- (void)ts_fetchAssetCollectionsTransToArray:(PHFetchResult *)result
              completionHandler:(void(^)(NSArray <PHAssetCollection *>*))handler
{
    NSMutableArray <PHAssetCollection *>*array = [NSMutableArray arrayWithCapacity:0];
    
    if (result.count == 0) {
        handler([NSArray arrayWithArray:array]);
    }
    
    [result enumerateObjectsUsingBlock:^(PHAssetCollection *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // --移除 已隐藏 和 最近删除 的PHAssetCollection
        if (obj.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumAllHidden && obj.assetCollectionSubtype != 1000000201) {
            if (obj.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                [array insertObject:obj atIndex:0];
            } else {
                [array addObject:obj];
            }
        }
        
        if (idx == result.count - 1) {
            handler([NSArray arrayWithArray:array]);
        }
        
    }];
}

- (void)ts_fetchAssetsTransToArray:(PHAssetCollection *)assetCollection
                 completionHandler:(void(^)(NSArray <PHAsset *>*))handler {
    NSMutableArray <PHAsset *>*array = [NSMutableArray arrayWithCapacity:0];
    PHFetchResult <PHAsset *>*result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj];
        if (idx == result.count - 1) {
            handler([NSArray arrayWithArray:array]);
        }
    }];
}

// 获取相册下的照片资源
- (void)ts_fetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection
                      completionHandler:(void(^)(NSArray <PHAsset *>*))handler
{
    [self ts_fetchAssetsTransToArray:assetCollection completionHandler:handler];
}
// 缓存单个照片资源
- (void)ts_cachingImageForAsset:(PHAsset *)asset
                     targetSize:(CGSize)size
              completionHandler:(void(^)(UIImage *, BOOL, NSTimeInterval))handler
{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize newSize = CGSizeMake(size.width * scale, size.height * scale);
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:newSize
                                              contentMode:PHImageContentModeAspectFill
                                                  options:nil
                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        handler(result ?  : [UIImage imageNamed:@"default"], asset.mediaType == PHAssetMediaTypeImage ? true : false, asset.duration);
    }];
    
    [((PHCachingImageManager *)[PHCachingImageManager defaultManager])startCachingImagesForAssets:@[asset] targetSize:newSize contentMode:PHImageContentModeAspectFill options:nil];    
}

// 获取单个照片资源
- (void)ts_requestImageForAsset:(PHAsset *)asset
                      targetSize:(CGSize)size
                        original:(BOOL)isOriginal
               completionHandler:(void(^)(UIImage *, BOOL, NSTimeInterval))handler
{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize newSize = CGSizeMake(size.width * scale, size.height * scale);
    PHImageRequestOptions *op = [[PHImageRequestOptions alloc] init];
    op.deliveryMode = isOriginal ? PHImageRequestOptionsDeliveryModeHighQualityFormat : PHImageRequestOptionsDeliveryModeOpportunistic;
    op.synchronous = YES;
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                                      targetSize:newSize
                                                     contentMode:PHImageContentModeAspectFill
                                                         options:op
                                                   resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                       handler(result ?  : [UIImage imageNamed:@"default"], asset.mediaType == PHAssetMediaTypeImage ? true : false, asset.duration);
                                                   }];
}

- (void)ts_requestImageDataForAsset:(PHAsset *)asset
                       original:(BOOL)isOriginal
              completionHandler:(void(^)(NSData *))handler
{
    PHImageRequestOptions *op = [[PHImageRequestOptions alloc] init];
    op.deliveryMode = isOriginal ? PHImageRequestOptionsDeliveryModeHighQualityFormat : PHImageRequestOptionsDeliveryModeOpportunistic;
    op.synchronous = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:op resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        handler(imageData);
    }];
}

// 获取分组图片和标题
- (void)ts_ts_cachingImageForAssetCollection:(PHAssetCollection *)assetCollection
                               targetSize:(CGSize)size
                        completionHandler:(void(^)(NSString *, UIImage *))handler
{
    if ([PHAsset fetchAssetsInAssetCollection:assetCollection options:nil].lastObject) {
        [self ts_cachingImageForAsset:[PHAsset fetchAssetsInAssetCollection:assetCollection options:nil].lastObject
                           targetSize:size
                    completionHandler:^(UIImage *image, BOOL isImage, NSTimeInterval duration) {
                        handler(assetCollection.localizedTitle,image);
                    }];
    } else {
        handler(assetCollection.localizedTitle,[UIImage imageNamed:@"default"]);
    }
    
}


@end
