//
//  TSPhotoGroupViewController.m
//  demo
//
//  Created by Ken on 2017/6/19.
//  Copyright © 2017年 Ken. All rights reserved.
//

#import "TSPhotoGroupViewController.h"
#import "TSPhotoViewController.h"
#import "TSGroupTableViewCell.h"


#import "TSAlbumHelper.h"

@interface TSPhotoGroupViewController ()
@property (nonatomic, copy) NSArray <PHAssetCollection *>*groups;
@end

@implementation TSPhotoGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"照片";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
    
    [self.tableView registerClass:[TSGroupTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TSGroupTableViewCell class])];
    __weak typeof(self) weakSelf = self;
    // --加载相册
    [[TSAlbumHelper sharedInstance] ts_loadAlbumGroupCompletionHandler:^(NSArray<PHAssetCollection *> *groups) {
        weakSelf.groups = groups;
        [weakSelf.tableView reloadData];
        // --默认跳转到 相机胶卷
        [weakSelf pushPhotoViewControllerWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO];
    }];
}

- (void)dismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TSGroupTableViewCell class]) forIndexPath:indexPath];
    
    [[TSAlbumHelper sharedInstance] ts_ts_cachingImageForAssetCollection:[self.groups objectAtIndex:indexPath.row]
                                                           targetSize:CGSizeMake(60, 60)
                                                    completionHandler:^(NSString *text, UIImage *image) {
                                                        cell.groupImageView.image = image;
                                                        cell.groupTextLabel.text = text;
                                                    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self pushPhotoViewControllerWithIndexPath:indexPath animated:YES];
}


- (void)pushPhotoViewControllerWithIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    TSPhotoContext *photoContext = [[TSPhotoContext alloc] init];
    photoContext.assetCollection = [self.groups objectAtIndex:indexPath.row];
    [[TSAlbumHelper sharedInstance] ts_fetchAssetsInAssetCollection:[self.groups objectAtIndex:indexPath.row]
                                                  completionHandler:^(NSArray<PHAsset *> *assets) {
                                                      photoContext.assetResult = assets;
                                                  }];
    
    TSPhotoViewController *photoViewController = [[TSPhotoViewController alloc] initWithPhotoContext:photoContext];
    [self.navigationController pushViewController:photoViewController animated:animated];
}

@end
