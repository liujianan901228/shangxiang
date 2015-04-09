//
//  AppNavigator.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RootNavigationViewController.h"
#import "HomeTabBarViewController.h"

@interface AppNavigator : NSObject

@property(nonatomic,strong)UINavigationController* currentContentNav;


@property(nonatomic,strong)NSMutableArray* alertViewArray;
@property(nonatomic,strong)NSMutableArray* actionSheetArray;
/**
 *   开启默认controller
 */
-(void)openDefaultMainViewController;


//跳转登录页面
-(void)turnToLoginGuide;;


//跳转订单查询页面
- (void)turnToOrderRecordPage;

//日历跳转求愿页面
- (void)calendarTurnWillingGuide;

-(void)switchToLivingTab:(NSInteger)index;

//>打开引导页面
-(void)openTutorialPage;

//>推送过来了消失
- (void)dismissWindow;

@end

