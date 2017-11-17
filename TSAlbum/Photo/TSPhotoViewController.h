//
//  TSPhotoViewController.h
//  demo
//
//  Created by Ken on 2017/6/19.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSPhotoContext.h"

@interface TSPhotoViewController : UIViewController

@property (nonatomic, strong) TSPhotoContext *photoContext;

- (instancetype)initWithPhotoContext:(TSPhotoContext *)photoContext;

@end
