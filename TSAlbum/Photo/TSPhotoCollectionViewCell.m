//
//  TSPhotoCollectionViewCell.m
//  demo
//
//  Created by Ken on 2017/6/20.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import "TSPhotoCollectionViewCell.h"
#import "TSPhotoManager.h"

@implementation TSPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        
        self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.chooseButton setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [self.chooseButton setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
        [self.chooseButton addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.chooseButton];
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false;
        self.chooseButton.translatesAutoresizingMaskIntoConstraints = false;
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.chooseButton
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:-2]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.chooseButton
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:2]];
    }
    return self;
}

- (void)chooseImage {
    
    if ([TSPhotoManager sharedInstance].maxPhotoCount == [TSPhotoManager sharedInstance].assets.count && !self.chooseButton.isSelected) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"最多只能选择%d张图",(int)[TSPhotoManager sharedInstance].assets.count] message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [_delegateViewController presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    self.chooseButton.selected = !self.chooseButton.isSelected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ts_photoCollectionViewCell:didCheck:)]) {
        [self.delegate ts_photoCollectionViewCell:self didCheck:self.chooseButton.isSelected];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.chooseButton.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.chooseButton.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            
        }];
        
    }];
}

@end
