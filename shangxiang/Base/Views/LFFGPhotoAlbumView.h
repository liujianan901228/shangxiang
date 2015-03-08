//
//  LFFGPhotoAlbumView.h
//  LaiFeng
//
//  Created by guoyaoyuan on 15/1/22.
//  Copyright (c) 2015年 live Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>


/// 显示时，一张图片的信息
@interface LFFGPhotoAlbumPageInfo : NSObject
@property (nonatomic, strong) UIImageView *thumbView;
@property (nonatomic, assign) CGSize thumbSize;
@property (nonatomic, strong) NSString *largeURL;
@property (nonatomic, assign) CGSize largeSize;
@end


/**
 显示一个小相册 (包含多张图，可以左右翻动)
 
 用法
 LFFGPhotoAlbumView *view = [LFFGPhotoAlbumView new];
 view.pageInfos = myPageInfos;
 [view showFromImageView:fromView toContainer:container];
 */
@interface LFFGPhotoAlbumView : UIView

- (void)showFromImageView:(UIImageView *)fromView toContainer:(UIView *)container;
- (void)dismiss;

@property (nonatomic, strong) NSArray *pageInfos; ///< LFFGPhotoAlbumPageInfo
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *container;
@property (nonatomic, readonly) int curPage; ///< 当前显示的页数、从0开始

@property (nonatomic, strong) UIImageView *blurBackground;
@property (nonatomic, strong) NSMutableArray *photoViews;
@property (nonatomic, strong) UIPageControl *pager;
@property (nonatomic, assign) BOOL isSheetDisplay;

@end
