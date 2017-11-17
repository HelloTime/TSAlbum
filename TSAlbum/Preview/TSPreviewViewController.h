//
//  TSPreviewViewController.h
//  demo
//
//  Created by Ken on 2017/6/20.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSPhotoContext.h"

@interface TSPreviewViewController : UICollectionViewController
+ (instancetype)controllerWithPhotoContext:(TSPhotoContext *)photoContext;
@property (nonatomic, strong) TSPhotoContext *photoContext;

@end
