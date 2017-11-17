//
//  TSGroupTableViewCell.m
//  demo
//
//  Created by Ken on 2017/6/19.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import "TSGroupTableViewCell.h"


@implementation TSGroupTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.groupImageView = [[UIImageView alloc] init];
        self.groupImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.groupImageView.clipsToBounds = true;
        
        self.groupTextLabel = [[UILabel alloc] init];
        self.groupTextLabel.font = [UIFont systemFontOfSize:16];
        
        [self.contentView addSubview:self.groupImageView];
        [self.contentView addSubview:self.groupTextLabel];
        
        self.groupImageView.translatesAutoresizingMaskIntoConstraints = false;
        self.groupTextLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.groupImageView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:10]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.groupImageView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:15]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.groupImageView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:60]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.groupImageView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:60]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.groupTextLabel
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.groupImageView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:10]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.groupTextLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0
                                                                      constant:0]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
