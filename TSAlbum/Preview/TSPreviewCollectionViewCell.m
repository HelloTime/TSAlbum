//
//  TSPreviewCollectionViewCell.m
//  demo
//
//  Created by Ken on 2017/6/20.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import "TSPreviewCollectionViewCell.h"

@implementation TSPreviewCollectionViewCell

-(void)prepareForReuse
{
    _imageView.image = nil;
    self.zoomeScrollView.zoomScale = 1.0f;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupContentView];

    }
    return self;
}


- (void)setupContentView {
    self.zoomeScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.zoomeScrollView.minimumZoomScale = 1.0;
    self.zoomeScrollView.maximumZoomScale = 2.0;
    self.zoomeScrollView.delegate = self;
    self.imageView = [[UIImageView alloc] initWithFrame:self.zoomeScrollView.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.contentView addSubview:self.zoomeScrollView];
    [self.zoomeScrollView addSubview:self.imageView];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] init];
    doubleTapGesture.numberOfTapsRequired = 2;
    [doubleTapGesture addTarget:self action:@selector(doubleTapClick:)];
    [self.zoomeScrollView addGestureRecognizer:doubleTapGesture];
    
    UITapGestureRecognizer *oneTapGesture = [[UITapGestureRecognizer alloc] init];
    [oneTapGesture addTarget:self action:@selector(oneTapClick:)];
    [self.zoomeScrollView addGestureRecognizer:oneTapGesture];
}

- (void)doubleTapClick:(UITapGestureRecognizer *)doubleTapGesture {
    if (self.zoomeScrollView.zoomScale != 1.0f)
    {
        [self.zoomeScrollView setZoomScale:1.0f animated:true];
    } else{
        
        //获得Cell的宽度
        CGFloat width = self.frame.size.width;
        
        //触及范围
        CGFloat scale = width / 2.0;
        
        //获取当前的触摸点
        CGPoint point = [doubleTapGesture locationInView:self.imageView];
        
        //对点进行处理
        CGFloat originX = MAX(0, point.x - width / scale);
        CGFloat originY = MAX(0, point.y - width / scale);
        
        //进行位置的计算
        CGRect rect = CGRectMake(originX, originY, width / scale , width / scale);
        
        //进行缩放
        [self.zoomeScrollView zoomToRect:rect animated:true];
        
    }
}

- (void)oneTapClick:(UITapGestureRecognizer *)oneTapGesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ts_previewCollectionViewCellDidClick:)]) {
        [self.delegate ts_previewCollectionViewCellDidClick:self];
    }
}

#pragma mark - <UIScrollViewDelegate>
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:true];
}

@end
