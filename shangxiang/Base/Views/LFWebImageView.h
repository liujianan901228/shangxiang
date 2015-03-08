//
//  LFWebImageView.h
//  LaiFeng
//
//  Created by guoyaoyuan on 15/1/9.
//  Copyright (c) 2015年 live Interactive. All rights reserved.
//

#import "YYAnimatedImageView.h"
#import "SDImageCache.h"

/**
 支持低内存显示GIF，支持占位图片，支持自定义setImage。
 */
@interface LFWebImageView : YYAnimatedImageView

- (void)setImageWithURL:(NSString *)url;

- (void)setImageWithURL:(NSString *)url
       placeHolderImage:(UIImage *)placeHolder
       errorHolderImage:(UIImage *)errorHolder;


@property (nonatomic, readonly, copy) NSString *imageURL; ///< 调用 setImageWithURL 后，可以从此处获取最新那个URL
@property (nonatomic, strong) UIImage *placeHolderImage; ///< 调用 setImageWithURL 后，下载完成之前的占位
@property (nonatomic, strong) UIImage *errorHolderImage; ///< 调用 setImageWithURL 后，下载失败之后的占位
@property (nonatomic, assign) BOOL ignoreHolder; ///< YES时，setImageWithURL不会用到 holderImage，能避免已显示的image被"冲跑"。默认NO


///< 自定义 setImage操作。如果该值不是nil，则图片获取成功后，会调用该方法来setImage显示。
@property (nonatomic, copy) void (^setImageAction)(LFWebImageView *view, SDImageCacheType type, UIImage *newImage);
///< 下载/获取图片完成后的回调，此时可以用.image访问。 fail==YES表示加载失败了
@property (nonatomic, copy) void (^loadCompletedAction)(LFWebImageView *view, SDImageCacheType type, BOOL fail);

@end
