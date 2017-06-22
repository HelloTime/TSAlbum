# TSPhotoBrow

Photos.framework封装的图片选择浏览器，适配iOS8以上

![QQ20170622-114725-HD](https://d.pcs.baidu.com/file/86ec50fb67089e2df9c65647a49f7b96?fid=2720586105-250528-877215429277402&time=1498105384&rt=pr&sign=FDTAERVC-DCb740ccc5511e5e8fedcff06b081203-iDXwb8NZ7RKKOupk9Bzx17CAlZI%3D&expires=8h&chkv=1&chkbd=1&chkpc=&dp-logid=4001133534106874136&dp-callid=0&r=632972815
)

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
