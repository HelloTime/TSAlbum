//
//  TSPhotoManager.h
//  demo
//
//  Created by Ken on 2017/6/20.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TSAlbumHelper.h"

@interface TSPhotoManager : NSObject

+ (instancetype)sharedInstance;
/** 图片尺寸 */
@property (nonatomic, assign) CGSize photoSize;
/** 图片数量 */
@property (nonatomic, assign) NSInteger maxPhotoCount;
/** 选中的照片资源 */
@property (nonatomic, strong) NSMutableArray <PHAsset *>*assets;
/** image的回传 */
@property (nonatomic, copy) void(^imageCallBack)(NSArray <UIImage *>*);
/** data的回传 */
@property (nonatomic, copy) void(^imageDataCallBack)(NSArray <NSData *>*);


/**
 发送图片

 @param isOriginal 是否原图
 */
- (void)sendOriginalImages:(BOOL)isOriginal;

@end
