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

#import "TSAuthorizationHelper.h"


@interface ViewController ()

@property (nonatomic, weak) TSSelectPhotoView *selectPhotoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    
    
    TSSelectPhotoView *view = [[TSSelectPhotoView alloc] init];
    view.delegateViewController = self;
    view.maxImageCount = 9;
    self.selectPhotoView = view;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:view];
    view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0 constant:0]];
    
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
    
    [TSAuthorizationHelper ts_checkLocationAuthorizationStatus:^(BOOL granted) {
        
    }];
    
}

- (void)refresh {
    self.selectPhotoView.images = nil;
    [self.selectPhotoView updateCollectionViewHeight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
