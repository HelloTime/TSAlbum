//
//  TSCameraHelper.m
//  demo
//
//  Created by Ken on 2017/6/22.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import "TSCameraHelper.h"
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>

@implementation TSCameraHelper

+ (void)checkPhotoLibraryAuthorizationStatus:(void(^)(BOOL))handler
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                    // --授权中
                case PHAuthorizationStatusNotDetermined:
                    handler(NO);
                    break;
                    // --没权限
                case PHAuthorizationStatusRestricted:
                    handler(NO);
                    break;
                    // --没权限
                case PHAuthorizationStatusDenied:
                    handler(NO);
                    break;
                    // --已授权
                case PHAuthorizationStatusAuthorized:
                    handler(YES);
                    break;
                    
                default:
                    break;
            }
        });
    }];
}

+ (void)checkCameraAuthorizationStatus:(void(^)(BOOL))handler
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(granted);
        });
    }];
}

@end
