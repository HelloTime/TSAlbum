//
//  TSPhotoCollectionReusableView.m
//  demo
//
//  Created by Ken on 2017/6/20.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import "TSPhotoCollectionReusableView.h"

@implementation TSPhotoCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.photoCountLabel = [[UILabel alloc] init];
        self.photoCountLabel.font = [UIFont systemFontOfSize:16];
        self.photoCountLabel.textAlignment = NSTextAlignmentCenter;
        self.photoCountLabel.textColor = [UIColor colorWithRed:111/255.0 green:113/255.0 blue:121/255.0 alpha:1.0];
        
        [self addSubview:self.photoCountLabel];
        self.photoCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.photoCountLabel
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0]];
        
         [self addConstraint:[NSLayoutConstraint constraintWithItem:self.photoCountLabel
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0]];
    }
    return self;
}

@end
