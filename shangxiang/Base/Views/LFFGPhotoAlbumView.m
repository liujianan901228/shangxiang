//
//  LFFGPhotoAlbumView.m
//  LaiFeng
//
//  Created by guoyaoyuan on 15/1/22.
//  Copyright (c) 2015年 live Interactive. All rights reserved.
//

#import "LFFGPhotoAlbumView.h"
#import "LFWebImageView.h"

#define kPadding 20


@implementation LFFGPhotoAlbumPageInfo
@end

/**
 一张可复用的瓦片(ScrollView)，可以用两指缩放、双击放大缩小。
 其内部包含一张 ImageView,用来动态加载网络图片。
 */
@interface LFFGPhotoAlbumTile : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, strong) LFWebImageView *img;
@property (nonatomic, assign) int page;
@end

@implementation LFFGPhotoAlbumTile

- (instancetype)init {
    self = super.init;
    if (!self) return nil;
    self.delegate = self;
    self.bouncesZoom = YES;
    self.maximumZoomScale = 3.0;
    self.multipleTouchEnabled = YES;
    self.alwaysBounceVertical = NO;
    self.frame = [UIScreen mainScreen].bounds;
    
    _img = [LFWebImageView new];
    _img.frame = [UIScreen mainScreen].bounds;
    _img.autoresizingMask = UIViewAutoresizingNone;
    _img.layer.anchorPoint = CGPointMake(0.5, 0.5);
    //_img.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.25].CGColor;
    //_img.layer.borderWidth = 0.5;
    _img.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.490];
    
    __weak typeof(self) _self = self;
    _img.loadCompletedAction = ^(LFWebImageView *view, SDImageCacheType type, BOOL fail) {
        [_self webImageDidLoad:view error:fail];
    };
    
    [self addSubview:_img];
    return self;
}

- (void)webImageDidLoad:(LFWebImageView *)imageView
                  error:(BOOL)error{
    
    [self setZoomScale:1.0];
    
    CGSize imgSize = {0};
    if (imageView.image) {
        imgSize = imageView.image.size;
    } else if (imageView.placeHolderImage) {
        imgSize = imageView.placeHolderImage.size;
    } else if (imageView.errorHolderImage) {
        imgSize = imageView.errorHolderImage.size;
    }
    if (imgSize.width == 0 || imgSize.height == 0) {
        return;
    }
    
    CGSize dest = CGSizeMake(self.width, imgSize.height / imgSize.width * self.width);
    self.contentSize = CGSizeMake(dest.width, dest.height < self.height ? self.height : dest.height);
    _img.size = dest;
    _img.center = CGPointMake(self.contentSize.width / 2, self.contentSize.height / 2);
    //CGRect rectVisiable = CGRectMake(0, (self.contentSize.height - self.height) / 2, self.width, self.height);
    //[self scrollRectToVisible:rectVisiable animated:NO];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _img;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

@end






@interface LFFGPhotoAlbumView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate, UIActionSheetDelegate>

@end

@implementation LFFGPhotoAlbumView

- (instancetype) init {
    self = super.init;
    if (!self) return nil;
    
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.820];
    self.frame = [UIScreen mainScreen].bounds;
    self.clipsToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
    tap2.delegate = self;
    tap2.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tap2];
    [tap requireGestureRecognizerToFail: tap2];
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    press.delegate = self;
    [self addGestureRecognizer:press];
    
    _blurBackground = UIImageView.new;
    _blurBackground.frame = self.bounds;
    _blurBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _photoViews = @[].mutableCopy;
    
    _scrollView = UIScrollView.new;
    _scrollView.frame = CGRectMake(self.left - kPadding/2, 0, self.width + kPadding, self.height);
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    
    _pager = [[UIPageControl alloc] init];
    _pager.userInteractionEnabled = NO;
    _pager.hidesForSinglePage = YES;
    _pager.width = self.width;
    _pager.height = 15;
    _pager.bottom = self.height - 15;
    _pager.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:_blurBackground];
    [self addSubview:_scrollView];
    [self addSubview:_pager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:ViewControllerDismissNotification object:nil];
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showFromImageView:(UIImageView *)fromView toContainer:(UIView *)container {
    if (self.pageInfos.count == 0 || fromView == nil || container == nil) return;
    if (container.width < 1 || container.height < 1) return;

    int page = -1;
    LFFGPhotoAlbumPageInfo *info = nil;
    for (NSUInteger i = 0; i < self.pageInfos.count; i++) {
        if (fromView == ((LFFGPhotoAlbumPageInfo *)self.pageInfos[i]).thumbView) {
            info = self.pageInfos[i];
            page = (int)i; 
            break;
        }
    }
    if (page == -1) return;
    
    
    
    /// 模糊背景 (性能差的就算了吧，会有点卡)
    fromView.hidden = YES;
    if ([[UIDevice currentDevice].machineModel hasPrefix:@"iPhone3"] ||
        [[UIDevice currentDevice].machineModel hasPrefix:@"iPhone4"] ||
        [[UIDevice currentDevice].machineModel hasPrefix:@"iPod3"]) {
        _blurBackground.image = [UIImage imageWithColor:[UIColor blackColor] size:_blurBackground.size];
    } else {
        _blurBackground.image = [[container snapshotImage] imageByBlurDark];
    }
    
    fromView.hidden = NO;
    
    
    /// 调整
    self.alpha = 1;
    self.size = container.size;
    self.container = container;
    self.blurBackground.alpha = 0;
    self.scrollView.alpha = 0;
    self.pager.alpha = 0;
    self.pager.numberOfPages = self.pageInfos.count;
    self.pager.currentPage = page;
    fromView.alpha = 0;
    [container addSubview:self];
    
    /// 把左右翻页Scroll调整好
    _scrollView.contentSize = CGSizeMake(_scrollView.width * self.pageInfos.count, _scrollView.height);
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.width * page, 0, _scrollView.width, _scrollView.height) animated:NO];
    
    
    /// 临时造一个视图来显示过度动画
    UIImageView *transView = UIImageView.new;
    transView.image = fromView.image;
    transView.clipsToBounds = fromView.clipsToBounds;
    transView.contentMode = fromView.contentMode;
    transView.frame = [fromView convertRect:fromView.bounds toView:self];
    [self insertSubview:transView belowSubview:_pager];
    
    
    /// 将原始缩略图按宽高比调整到宽度合适
    CGSize imgSize = fromView.image.size;
    if (imgSize.width < 1 || imgSize.height < 1) {
        imgSize = info.thumbSize;
    }
    if (imgSize.width < 1 || imgSize.height < 1) {
        imgSize = self.size;
    }
    imgSize = CGSizeMake(self.width, imgSize.height / imgSize.width * self.width);
    
    
    float oneTime = 0.18;
    [UIView setAnimationsEnabled:YES];
    if (kiOS7Later) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
    
    
    /// 背景模糊动画
    [UIView animateWithDuration:oneTime*2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
        _pager.alpha = 1;
        _blurBackground.alpha = 1;
    }completion:^(BOOL finished) {
        fromView.alpha = 1;
    }];
    
    /// 放大动画
    [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
        transView.frame = CGRectMake(0, (self.height - imgSize.height) / 2, imgSize.width, imgSize.height);
        transView.layer.transformScale = 1.03;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            transView.layer.transformScale = 1.0;
        }completion:^(BOOL finished) {
            [self scrollViewDidScroll:_scrollView];
            _scrollView.alpha = 1;
            [self hidePager];
            [transView removeFromSuperview];
        }];
    }];
}

- (void)dismiss {
    [UIView setAnimationsEnabled:YES];
    
    if (kiOS7Later) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    LFFGPhotoAlbumTile *tile = [self getTileForPage:self.curPage];
    
    LFFGPhotoAlbumPageInfo *info = nil;
    if (self.curPage < self.pageInfos.count) info = self.pageInfos[self.curPage];
    
    ///不知道回哪儿去..给个淡出动画吧
    if (info.thumbView == nil) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
            self.backgroundColor = [UIColor clearColor];
            self.alpha = 0.0;
            _pager.alpha = 0.0;
            self.layer.transformScale = 1.2;
        }completion:^(BOOL finished) {
            self.layer.transformScale = 1.0;
            [self removeFromSuperview];
        }];
        return;
    }
    
    /// 回到某个视图去，给个缩放动画
    UIImageView *transView = [UIImageView new];
    transView.image = tile.img.image;
    if(transView.image == nil) transView.image = info.thumbView.image;
    transView.clipsToBounds = tile.img.clipsToBounds;
    transView.contentMode = tile.img.contentMode;
    transView.frame = [tile.img convertRect:tile.img.bounds toView:self];
    [self insertSubview:transView belowSubview:_pager];
    _scrollView.alpha = 0;
    info.thumbView.alpha = 0;
    
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundColor = [UIColor clearColor];
        _pager.alpha = 0.0;
        _blurBackground.alpha = 0.0;
        
        transView.clipsToBounds = info.thumbView.clipsToBounds;
        transView.contentMode = info.thumbView.contentMode;
        transView.layer.borderColor = info.thumbView.layer.borderColor;
        transView.layer.borderWidth = info.thumbView.layer.borderWidth;
        CGRect r = [info.thumbView convertRect:info.thumbView.bounds toView:self];
        transView.frame = r;
        transView.layer.transformScale = 1;
    }completion:^(BOOL finished) {
        info.thumbView.alpha = 1.0;
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveLinear animations:^{
            transView.alpha = 0;
        }completion:^(BOOL finished) {
            [transView removeFromSuperview];
            [tile setZoomScale:1.0 animated:NO];
            [self removeFromSuperview];
        }];
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self doReuseTiles];
    
    int page = _scrollView.contentOffset.x / _scrollView.width + 0.5;
    
    for (int i = page - 1; i <= page + 1; i++) {
        if (i >= 0 && i < self.pageInfos.count) {
            if (![self getTileForPage:i]) {
                LFFGPhotoAlbumTile *tile = [self getOneReuseTile];
                tile.page = i;
                tile.left = (self.width + kPadding) * i + kPadding / 2;
                
                LFFGPhotoAlbumPageInfo *info = self.pageInfos[i];
                
                NSString *url = info.largeURL;
                UIImage *holder = info.thumbView.image;
                [tile setZoomScale:1.0 animated:NO];
                if (holder && holder.size.width) {
                    CGSize dest = CGSizeMake(tile.width, holder.size.height / holder.size.width * tile.width);
                    tile.contentSize = CGSizeMake(dest.width, dest.height < self.height ? self.height : dest.height);
                    //tile.contentSize = CGSizeMake(dest.width, self.height);
                    tile.img.size = dest;
                    tile.img.center = CGPointMake(tile.contentSize.width / 2, tile.contentSize.height / 2);
                    
                    CGRect rectVisiable = CGRectMake(0, (tile.contentSize.height - tile.height) / 2, tile.width, tile.height);
                    [tile scrollRectToVisible:rectVisiable animated:NO];
                }
                [tile.img setImageWithURL:url placeHolderImage:holder errorHolderImage:holder];
                [self.scrollView addSubview:tile];
            }
        }
    }
    
    _pager.currentPage = self.curPage;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        _pager.alpha = 1;
    }completion:^(BOOL finish) {
    }];
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self hidePager];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self hidePager];
}


- (void)hidePager {
    [UIView animateWithDuration:0.3 delay:0.8 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
        _pager.alpha = 0;
    }completion:^(BOOL finish) {
    }];
}


- (void)doReuseTiles {
    for (LFFGPhotoAlbumTile *tile in _photoViews) {
        if (tile.superview) {
            if (tile.left > _scrollView.contentOffset.x + _scrollView.width * 2||
                tile.right < _scrollView.contentOffset.x - _scrollView.width) {
                [tile removeFromSuperview];
                tile.page = -1;
                tile.img.image = nil;
            }
        }
    }
}

- (LFFGPhotoAlbumTile *)getOneReuseTile {
    LFFGPhotoAlbumTile *result = nil;
    for (LFFGPhotoAlbumTile *tile in _photoViews) {
        if (!tile.superview) {
            result = tile;
            break;
        }
    }
    if (!result) {
        result = LFFGPhotoAlbumTile.new;
        result.frame = self.bounds;
        result.img.frame = result.bounds;
        result.height += 1; //当图片和屏幕高度一致时，避免上下滑动
        result.page = -1;
        [_photoViews addObject:result];
    }
    return result;
}

- (LFFGPhotoAlbumTile *)getTileForPage:(int)page {
    for (LFFGPhotoAlbumTile *tile in _photoViews) {
        if (tile.page == page) {
            return tile;
        }
    }
    return nil;
}


- (int)curPage {
    return _scrollView.contentOffset.x / _scrollView.width + 0.5;
}



- (void)showHUD:(NSString *)msg {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:self animated:YES];
    });
}


- (void) doSave {
    LFFGPhotoAlbumTile *tile = [self getTileForPage:self.curPage];
    if (tile.img.image) {
        UIImageWriteToSavedPhotosAlbum(tile.img.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    } else {
        [self showHUD:@"保存失败,请稍后重试"];
    }
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [self showHUD:@"保存成功"];
    }else{
        NSLog(@"保存错误:%@",error);
        [self showHUD:@"保存失败,请检查设置>隐私>照片"];
    }
}


- (void)doubleTap {
    LFFGPhotoAlbumTile *tile = [self getTileForPage:self.curPage];
    if (tile) {
        if (tile.zoomScale > 1) {
            [tile setZoomScale:1 animated:YES];
        } else {
            [tile setZoomScale:tile.maximumZoomScale animated:YES];
        }
    }
}

- (void)longPress {
    if (self.isSheetDisplay) return;
    self.isSheetDisplay = YES;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机", nil];
    sheet.destructiveButtonIndex = 1;
    [sheet showInView:self.window];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.isSheetDisplay = NO;
    
    if (buttonIndex == 0) { //保存
        [self doSave];
    }

}


@end
