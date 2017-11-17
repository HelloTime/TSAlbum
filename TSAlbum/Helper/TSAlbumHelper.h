//
//  TSAlbumHelper.h
//  demo
//
//  Created by Ken on 2017/6/19.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Photos/PHAsset.h>
#import <Photos/PHPhotoLibrary.h>
#import <Photos/PHCollection.h>
#import <Photos/PHImageManager.h>
#import <Photos/PHFetchOptions.h>

@interface TSAlbumHelper : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSMutableArray <UIImage *>*selectImages;
@property (nonatomic, strong) NSMutableArray <NSData *>*selectImageDatas;

/**
 加载相册分组

 @param handler 完成的回调
 */
- (void)ts_loadAlbumGroupCompletionHandler:(void(^)(NSArray <PHAssetCollection *>*))handler;

/**
 缓存图片

 @param asset 照片资源
 @param size 尺寸
 @param handler 完成的回调
 */
- (void)ts_cachingImageForAsset:(PHAsset *)asset
                      targetSize:(CGSize)size
               completionHandler:(void(^)(UIImage *, BOOL, NSTimeInterval))handler;
/**
 获取分组下面的照片资源

 @param assetCollection group
 @param handler 完成的回调
 */
- (void)ts_fetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection
                      completionHandler:(void(^)(NSArray <PHAsset *>*))handler;

/**
 请求图片

 @param asset 照片资源
 @param size 尺寸
 @param isOriginal 是否原图
 @param handler 完成的回调
 */
- (void)ts_requestImageForAsset:(PHAsset *)asset
                     targetSize:(CGSize)size
                       original:(BOOL)isOriginal
              completionHandler:(void(^)(UIImage *, BOOL, NSTimeInterval))handler;

/**
 请求图片Data

 @param asset 照片资源
 @param isOriginal 是否原图
 @param handler 完成的回调
 */
- (void)ts_requestImageDataForAsset:(PHAsset *)asset
                           original:(BOOL)isOriginal
                  completionHandler:(void(^)(NSData *))handler;

/**
 请求分组的最后一张图片和分组标题

 @param assetCollection group
 @param size 尺寸
 @param handler 完成的回调
 */
- (void)ts_ts_cachingImageForAssetCollection:(PHAssetCollection *)assetCollection
                               targetSize:(CGSize)size
                        completionHandler:(void(^)(NSString *, UIImage *))handler;
@end
