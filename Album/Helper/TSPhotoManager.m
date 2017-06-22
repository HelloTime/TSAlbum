//
//  TSPhotoManager.m
//  demo
//
//  Created by Ken on 2017/6/20.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import "TSPhotoManager.h"

@implementation TSPhotoManager

static TSPhotoManager  * _singleton = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[TSPhotoManager alloc] init];
        _singleton.assets = [NSMutableArray arrayWithCapacity:0];
    });
    return _singleton;
}

- (void)sendOriginalImages:(BOOL)isOriginal {
    
    __weak typeof(self)weakSelf = self;
    
    NSMutableArray <UIImage *>*images = [NSMutableArray arrayWithCapacity:0];
    NSArray <PHAsset *>*array = [NSArray arrayWithArray:self.assets];
    [self.assets removeAllObjects];
    if (self.imageCallBack) {
        for (PHAsset *asset in array) {
            
            [[TSAlbumHelper sharedInstance] ts_requestImageForAsset:asset
                                                         targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight)
                                                           original:isOriginal
                                                  completionHandler:^(UIImage *image, BOOL isImage, NSTimeInterval duration) {
                                                      
                                                      [images addObject:image];
                                                      
                                                      if (images.count == array.count) {
                                                          weakSelf.imageCallBack([NSArray arrayWithArray:images]);
                                                      }
                                                      
                                                  }];
            
        }
    }
    
    NSMutableArray <NSData *>*imageDatas = [NSMutableArray arrayWithCapacity:0];
    
    if (self.imageDataCallBack) {
        for (PHAsset *asset in array) {
            [[TSAlbumHelper sharedInstance] ts_requestImageDataForAsset:asset
                                                               original:isOriginal
                                                      completionHandler:^(NSData *imageData) {
                                                          
                                                          [imageDatas addObject:imageData];
                                                          
                                                          if (imageDatas.count == array.count) {
                                                              weakSelf.imageDataCallBack([NSArray arrayWithArray:imageDatas]);
                                                          }
                                                          
                                                      }];
        }
    }
    
}


@end
