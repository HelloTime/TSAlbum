//
//  TSAuthorizationHelper.h
//  demo
//
//  Created by Ken on 2017/6/22.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSAuthorizationHelper : NSObject
/**
 * 检查系统"照片"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (void)ts_checkPhotoLibraryAuthorizationStatus:(void(^)(BOOL granted))handler;

/**
 * 检查系统"相机"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (void)ts_checkCameraAuthorizationStatus:(void(^)(BOOL granted))handler;

/**
 * 检查系统"麦克风"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (void)ts_checkAudioAuthorizationStatus:(void(^)(BOOL granted))handler;

/**
 * 检查系统"网络"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (void)ts_checkNetworkAuthorizationStatus:(void(^)(BOOL granted))handler;

/**
 * 检查系统"通讯录"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (void)ts_checkAddressBookAuthorizationStatus:(void(^)(BOOL granted))handler;


@end
