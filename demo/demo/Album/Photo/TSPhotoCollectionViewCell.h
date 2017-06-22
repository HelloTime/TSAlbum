//
//  TSPhotoCollectionViewCell.h
//  demo
//
//  Created by Ken on 2017/6/20.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TSPhotoCollectionViewCell;
@protocol TSPhotoCollectionViewCellDelegate <NSObject>

- (void)ts_photoCollectionViewCell:(TSPhotoCollectionViewCell *)cell didCheck:(BOOL)isCheck;

@end

@interface TSPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *chooseButton;

@property (nonatomic, weak) id<TSPhotoCollectionViewCellDelegate>delegate;

@property (nonatomic, weak) UIViewController *delegateViewController;

@end
