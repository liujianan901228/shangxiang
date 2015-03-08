//
//  LFWebImageView.m
//  LaiFeng
//
//  Created by guoyaoyuan on 15/1/9.
//  Copyright (c) 2015年 live Interactive. All rights reserved.
//

#import "LFWebImageView.h"
#import "SDWebImageManager.h"
#import "UIView+WebCacheOperation.h"


@interface LFWebImageView ()
@property (nonatomic, readwrite, copy) NSString *imageURL;
@end

@implementation LFWebImageView

- (void)setImageWithURL:(NSString *)url {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
    
    self.imageURL = url;
    if (!self.ignoreHolder) {
        dispatch_main_async_safe(^{
            self.image = self.placeHolderImage;
        });
    }
    if (url.length == 0) return;
    
    // 尝试从内存缓存取，取到的话就直接显示，跳过其他步骤 (即同步显示，无延迟)
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:url]];
    SDImageCache *cache = [SDWebImageManager sharedManager].imageCache;
    UIImage *memImage = [cache imageFromMemoryCacheForKey:key];
    if (memImage) {
        dispatch_main_async_safe(^{
            if (self.setImageAction) {
                self.setImageAction(self, SDImageCacheTypeMemory, memImage);
            } else {
                self.image = memImage;
            }
            if (self.loadCompletedAction) self.loadCompletedAction(self, SDImageCacheTypeMemory, NO);
        });
        return;
    }
    
    __weak typeof(self) _self = self;
    id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        typeof(_self) self = _self;
        if (!self) return;
        
        dispatch_main_sync_safe(^{
            if (image) {
                if (self.setImageAction) {
                    self.setImageAction(self, SDImageCacheTypeMemory, image);
                } else {
                    self.image = image;
                }
                if (self.loadCompletedAction) self.loadCompletedAction(self, cacheType, NO);
            } else {
                if (!self.ignoreHolder) {
                    self.image = self.errorHolderImage;
                }
                if (self.loadCompletedAction) self.loadCompletedAction(self, cacheType, YES);
            }
        });
    }];
    [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    
}

- (void)setImageWithURL:(NSString *)url
       placeHolderImage:(UIImage *)placeHolder
       errorHolderImage:(UIImage *)errorHolder {
    self.placeHolderImage = placeHolder;
    self.errorHolderImage = errorHolder;
    [self setImageWithURL:url];
}

@end
