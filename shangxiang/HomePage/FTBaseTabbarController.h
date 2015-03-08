//
//  FTBaseTabbarController.h
//  Fetion
//
//  Created by 闻 小叶 on 14-1-15.
//  Copyright (c) 2014年 chinasofti. All rights reserved.
//

#import <UIKit/UIKit.h>


#define MAINTABCOUNT 5              //item 的个数
#define TabItemWidth 64             //每个Item的宽
#define TabItemHeight 49            //每个item的高
#define TabItemImageWidth 33        //item中图片的宽
#define TabItemImageHeight 33       //item中图片的高
#define TabSideMarginX 15.5
#define TabSideMarginY 2
#define TabSpacing 0

//tabbaritem的类型
typedef enum
{
    KSessionBarItemType = 0,   //会话类型
    KFriendBarTItemype = 1,    //好友
    KAdressBookBarItemType = 2,//通讯录
    KBesideBarItemType = 3,    //身边
    KMoreBarItemType = 4,      //更多
}KTabbarItemType;

@class FTBaseNavigationController;
@interface FTBaseTabbarController : UITabBarController
{
    
}


@property (nonatomic, strong) UIImage         *tabBarBackgroundImage;// 整个tabBar的背景
@property (nonatomic, strong) NSMutableArray  *unSelectedImageArray; // 非选中效果的tabBarItem数组
@property (nonatomic, strong) NSMutableArray  *selectedImageArray;   // 选中效果的tabBarItem数组
@property (nonatomic, strong) NSMutableArray  *itemBgImageViewArray; // item背景UIImageView数组
@property (nonatomic, assign) int             lastSelectedIndex;     // 上一次选中的tabBarItem的index

@end
