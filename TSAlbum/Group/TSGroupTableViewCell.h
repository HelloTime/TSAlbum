//
//  TSGroupTableViewCell.h
//  demo
//
//  Created by Ken on 2017/6/19.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSGroupTableViewCell : UITableViewCell
/** 分组图片 */
@property (nonatomic, strong) UIImageView *groupImageView;
/** 分组名称 */
@property (nonatomic, strong) UILabel *groupTextLabel;
@end
