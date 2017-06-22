//
//  TSSelectPhotoView.h
//  demo
//
//  Created by Ken on 2017/6/22.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TSSelectPhotoView : UIView

@property (nonatomic, strong) NSMutableArray <UIImage *>*images;

/**
 最大的图片数量   默认为3
 */
@property (nonatomic, assign) NSInteger maxImageCount;

@property (nonatomic, weak) UIViewController *delegateViewController;

- (void)updateCollectionViewHeight;

@end
