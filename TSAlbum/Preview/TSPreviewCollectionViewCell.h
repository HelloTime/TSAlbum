//
//  TSPreviewCollectionViewCell.h
//  demo
//
//  Created by Ken on 2017/6/20.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSPreviewCollectionViewCell;
@protocol TSPreviewCollectionViewCellDelegate <NSObject>

- (void)ts_previewCollectionViewCellDidClick:(TSPreviewCollectionViewCell *)cell;

@end

@interface TSPreviewCollectionViewCell : UICollectionViewCell <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *zoomeScrollView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, weak) id<TSPreviewCollectionViewCellDelegate>delegate;

@end
