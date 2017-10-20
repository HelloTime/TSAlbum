//
//  TSAuthorizationHelper.m
//  demo
//
//  Created by Ken on 2017/6/22.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import "TSAuthorizationHelper.h"

@import Photos;
@import AVFoundation;
@import CoreTelephony;
@import CoreLocation;
@import Contacts;
@import AddressBook;
@import Contacts;

@implementation TSAuthorizationHelper
//跳转到应用的设置页面
//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
// 相册
+ (void)ts_checkPhotoLibraryAuthorizationStatus:(void(^)(BOOL))handler
{
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    switch (photoAuthorStatus) {
        case PHAuthorizationStatusAuthorized:
            handler(YES);
            break;
        case PHAuthorizationStatusDenied:
            handler(NO);
            break;
        case PHAuthorizationStatusNotDetermined:
            [self ts_requestPhotoLibraryAuthorizationStatus:handler];
            break;
        case PHAuthorizationStatusRestricted:
            handler(NO);
            break;
        default:
            break;
    }
}
+ (void)ts_requestPhotoLibraryAuthorizationStatus:(void(^)(BOOL))handler {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
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
    }];
}

// 相机
+ (void)ts_checkCameraAuthorizationStatus:(void(^)(BOOL))handler
{
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//相机权限
    
    switch (AVstatus) {
        case AVAuthorizationStatusAuthorized:
            handler(YES);
            break;
        case AVAuthorizationStatusDenied:
            handler(NO);
            break;
        case AVAuthorizationStatusNotDetermined:
            [self ts_requestCameraAuthorizationStatus:handler];
            break;
        case AVAuthorizationStatusRestricted:
            handler(NO);
            break;
        default:
            break;
    }
}
+ (void)ts_requestCameraAuthorizationStatus:(void(^)(BOOL))handler
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        handler(granted);
    }];
}

// 麦克风
+ (void)ts_checkAudioAuthorizationStatus:(void(^)(BOOL))handler
{
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];//麦克风权限
    
    switch (AVstatus) {
        case AVAuthorizationStatusAuthorized:
            handler(YES);
            break;
        case AVAuthorizationStatusDenied:
            handler(NO);
            break;
        case AVAuthorizationStatusNotDetermined:
            [self ts_requestAudioAuthorizationStatus:handler];
            break;
        case AVAuthorizationStatusRestricted:
            handler(NO);
            break;
        default:
            break;
    }
}
+ (void)ts_requestAudioAuthorizationStatus:(void(^)(BOOL))handler
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        handler(granted);
    }];
}

// 网络
+ (void)ts_checkNetworkAuthorizationStatus:(void(^)(BOOL))handler {
    
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    switch (state) {
        case kCTCellularDataRestricted:
            handler(YES);
            break;
        case kCTCellularDataNotRestricted:
            handler(NO);
            break;
        case kCTCellularDataRestrictedStateUnknown:
            [self ts_requestNetworkAuthorizationStatus:handler];
            break;
        default:
            break;
    }
}
+ (void)ts_requestNetworkAuthorizationStatus:(void(^)(BOOL))handler {
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state){
        //获取联网状态
        switch (state) {
                // --已授权
            case kCTCellularDataRestricted:
                handler(YES);
                break;
                // --授权中
            case kCTCellularDataNotRestricted:
                handler(NO);
                break;
                // --没权限
            case kCTCellularDataRestrictedStateUnknown:
                handler(NO);
                break;
            default:
                break;
        };
    };
}

// 通讯录
+ (void)ts_checkAddressBookAuthorizationStatus:(void(^)(BOOL))handler {

#ifdef __IPHONE_9_0
 
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (status) {
        case CNAuthorizationStatusAuthorized:
            handler(YES);
            break;
        case CNAuthorizationStatusDenied:
            handler(NO);
            break;
        case CNAuthorizationStatusRestricted:
            handler(NO);
            break;
        case CNAuthorizationStatusNotDetermined:
            [self ts_requestAddressBookAuthorizationStatus:handler];
            break;
            
    }
    
#else
    
    ABAuthorizationStatus ABstatus = ABAddressBookGetAuthorizationStatus();
    switch (ABstatus) {
        case kABAuthorizationStatusAuthorized:
            handler(YES);
            break;
        case kABAuthorizationStatusDenied:
            handler(NO);
            break;
        case kABAuthorizationStatusNotDetermined:
            [self ts_requestAddressBookAuthorizationStatus:handler];
            break;
        case kABAuthorizationStatusRestricted:
            handler(NO);
            break;
        default:
            break;
    }
    
#endif

}
+ (void)ts_requestAddressBookAuthorizationStatus:(void(^)(BOOL))handler {
    
#ifdef __IPHONE_9_0
    
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        handler(granted);
    }];
    
#else
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        handler(granted);
    });
    
#endif
    

}


@end
