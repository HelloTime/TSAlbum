//
//  TSPhotoContext.h
//  demo
//
//  Created by Ken on 2017/6/20.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TSAlbumHelper.h"

@interface TSPhotoContext : NSObject

/** 图片尺寸 */
@property (nonatomic, assign) CGSize photoSize;

/** 当前照片的group */
@property (nonatomic, strong) PHAssetCollection * assetCollection;

/** 照片group的asset集合 */
@property (nonatomic, copy) NSArray <PHAsset *>*assetResult;

/** 预览时的起始位置 */
@property (nonatomic, assign) NSInteger startingIndex;


@end
