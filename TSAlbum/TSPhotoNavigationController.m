//
//  TSPhotoNavigationController.m
//  demo
//
//  Created by Ken on 2017/6/19.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import "TSPhotoNavigationController.h"
#import "TSPhotoGroupViewController.h"

@interface TSPhotoNavigationController ()

@end

@implementation TSPhotoNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewControllers = @[[TSPhotoGroupViewController new]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
