//
//  FTBaseTabbarController.m
//  Fetion
//
//  Created by 闻 小叶 on 14-1-15.
//  Copyright (c) 2014年 chinasofti. All rights reserved.
//

#import "FTBaseTabbarController.h"

@implementation FTBaseTabbarController


-(void)dealloc
{
    self.tabBarBackgroundImage = nil;
    self.unSelectedImageArray = nil;
    self.selectedImageArray = nil;
    self.itemBgImageViewArray = nil;
}



#pragma mark - itemIndex methods

//加载tabbar上面的资源图片
-(void)addAllImagesResource
{
    self.tabBarBackgroundImage = [UIImage imageForKey:@"background_tabbar"];
    
    //未选中的图标
    NSMutableArray *aunSelectedImageArray = [[NSMutableArray alloc] initWithObjects:
                                             [UIImage  imageNamed:@"icon_home_normal"],
                                             [UIImage imageNamed:@"icon_discover_normal"],
                                             [UIImage imageNamed:@"icon_calendar_normal"],
                                             [UIImage imageNamed:@"icon_my_normal"], nil];
    self.unSelectedImageArray = aunSelectedImageArray;
    
    //选中的图片
    NSMutableArray *aselectedImageArray = [[NSMutableArray alloc] initWithObjects:
                                           [UIImage imageNamed:@"icon_home_pressed"],
                                           [UIImage imageNamed:@"icon_discover_pressed"],
                                           [UIImage imageNamed:@"icon_calendar_pressed"],
                                           [UIImage imageNamed:@"icon_my_pressed"], nil];
    self.selectedImageArray = aselectedImageArray;
    
    
    self.itemBgImageViewArray = [NSMutableArray array];
    
    //设置tabbar的items图标
    for (int i = 0; i < 4; i++)
    {
        UIImageView *itemBg  = [[UIImageView alloc] initWithFrame:CGRectMake(TabSideMarginX +TabItemWidth * i + TabSpacing * i, TabSideMarginY, TabItemImageWidth, TabItemImageHeight)];
        itemBg.contentMode = UIViewContentModeScaleAspectFit;
        [self.itemBgImageViewArray addObject:itemBg];
    }
}

//设置视图控件
-(void)setAllViewsToTabbar
{
    //修正tabbar的frame高度，默认高度是49
    self.tabBar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - TabItemHeight, [UIScreen mainScreen].bounds.size.width, TabItemHeight);
    
    //设置tabbar的背景图
    if(self.tabBarBackgroundImage)
    {
        [self.tabBar setBackgroundImage:self.tabBarBackgroundImage];
    }

    //设置tabbarItem文字颜色和位置
    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:239/255.0 green:103.0/255.0 blue:62.0/255.0 alpha:1.0], NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    
    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0], NSForegroundColorAttributeName,[UIFont systemFontOfSize:12.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -3)];

    //设置tabbar的items图表
    for (int i = 0; i < [self.itemBgImageViewArray count]; i++)
    {
        UIImageView *itemBg  = [self.itemBgImageViewArray objectAtIndex:i];
        itemBg.image = [self.unSelectedImageArray objectAtIndex:i];
        [self.tabBar addSubview:itemBg];
    }
    
    self.selectedIndex = 0;
}

- (NSArray*)addTabBarItem
{
    NSMutableArray* itemsArray = [[NSMutableArray alloc]initWithCapacity:5];
    for (int i=0; i<self.selectedImageArray.count; i++) {
        UITabBarItem* tabBarItem = [[UITabBarItem alloc]initWithTitle:@"12" image:[self.selectedImageArray objectAtIndex:i]  selectedImage:[self.unSelectedImageArray objectAtIndex:i]];
        [itemsArray addObject:tabBarItem];
    }
    return itemsArray;
}



#pragma mark - View lifecycle

//设置上次的选中
- (void)setLastSelectedIndex:(int)lastSelectedIndex
{
    if (_lastSelectedIndex != lastSelectedIndex)
    {
        //将上次的选中效果取消
        UIImageView *lastSelectedImageView = (UIImageView *)[self.itemBgImageViewArray objectAtIndex:_lastSelectedIndex];
        
        lastSelectedImageView.image = [self.unSelectedImageArray objectAtIndex:_lastSelectedIndex];
        _lastSelectedIndex = lastSelectedIndex;
    }
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    _lastSelectedIndex = 0;
    
    [self addAllImagesResource];
    [self setAllViewsToTabbar]; //添加完资源后才能调用
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.selectedIndex = [tabBar.items indexOfObject:item];
}

@end
