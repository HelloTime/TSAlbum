//
//  ViewController.m
//  demo
//
//  Created by Ken on 2017/6/16.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import "ViewController.h"

#import "TSSelectPhotoView.h"
#import "TSAlbumHelper.h"

#import "TSCameraHelper.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    TSSelectPhotoView *view = [[TSSelectPhotoView alloc] init];
    view.delegateViewController = self;
    view.maxImageCount = 9;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:view];
    view.backgroundColor = [UIColor grayColor];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0 constant:80]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0 constant:0]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
