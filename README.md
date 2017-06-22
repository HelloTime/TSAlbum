# TSPhotoBrow

Photos.framework封装的图片选择浏览器，适配iOS8以上

![QQ20170622-114725-HD](TSAlbum/Screen/QQ20170622-114725-HD.gif)

使用方法

```
__weak typeof(self)weakSelf = self;

    // --检查相册权限

    [TSCameraHelper checkPhotoLibraryAuthorizationStatus:^(BOOL granted) {

        if (granted) {

            // --设置图片回调

            [TSPhotoManager sharedInstance].imageCallBack = ^(NSArray<UIImage *> *images) {

                [weakSelf.images addObjectsFromArray:images];

                [weakSelf updateCollectionViewHeight];

                

            };

            // --设置Data回调

            [TSPhotoManager sharedInstance].imageDataCallBack = ^(NSArray<NSData *> *imageDatas) {

                

            };

            // --设置需要的图片尺寸

            [TSPhotoManager sharedInstance].photoSize = CGSizeMake(PhotoItemWH, PhotoItemWH);

            // --设置图片数量

            [TSPhotoManager sharedInstance].maxPhotoCount = weakSelf.maxImageCount - weakSelf.images.count;

            // --跳转相册

            [weakSelf.delegateViewController presentViewController:[TSPhotoNavigationController new] animated:YES completion:nil];
![QQ20170622-114725-HD](/Users/liuhuiping/Git/TSAlbum/Screen/QQ20170622-114725-HD.gif)
        }

    }];

```
