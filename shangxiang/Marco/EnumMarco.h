//
//  EnumMarco.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#ifndef shangxiang_EnumMarco_h
#define shangxiang_EnumMarco_h

#define HEIGHT_LINE 0.5f
#define SIZE_FONT_DICOVER_CONTENT 14
#define WIDTH_DICOVER_CONTENT 250
#define HEIGHT_BUTTON 40

#define COLOR_NAV_BAR 0xefeacd
#define COLOR_BG_HIGHLIGHT 0xf6f7f7
#define COLOR_BG_NORMAL 0xf2f1f1
#define COLOR_FONT_NORMAL 0x363636
#define COLOR_FONT_HIGHLIGHT 0xdca358
#define COLOR_FONT_FORM_NORMAL 0x333333
#define COLOR_FONT_FORM_HINT 0xafafaf
#define COLOR_FORM_BG_INPUT 0xffffff
#define COLOR_LINE_NORMAL 0xafafaf
#define COLOR_LINE_HIGHLIGHT 0xe1e1e1
#define COLOR_FORM_BG_BUTTON_NORMAL 0xdca358
#define COLOR_FORM_BG_BUTTON_PRESSED 0xd1d1d2
#define COLOR_FORM_BG_BUTTON_HIGHLIGHT 0xe08708
#define COLOR_FORM_BG_BUTTON_GRAY 0xefefef

#define TAG_DESIRE_0 90
#define TAG_DESIRE_1 91
#define TAG_DESIRE_2 92
#define TAG_DESIRE_3 93
#define TAG_DESIRE_4 94
#define TAG_DESIRE_5 95
#define TAG_DESIRE_6 96

#define TITLE_DESIRE_0 @"财富"
#define TITLE_DESIRE_1 @"健康"
#define TITLE_DESIRE_2 @"求子"
#define TITLE_DESIRE_3 @"平安"
#define TITLE_DESIRE_4 @"学业"
#define TITLE_DESIRE_5 @"姻缘"
#define TITLE_DESIRE_6 @"事业"

typedef NS_ENUM(NSInteger, WishType)
{
    WishType_Wealth = 1,//@"财富
    WishType_Health = 2,//@"健康"
    WishType_Praying = 3,//@"求子"
    WishType_Ping = 4,//@"平安"
    WishType_Learning = 5,//@"学业"
    WishType_Marriage = 6,//@"姻缘"
    WishType_Career = 7//@"事业"
};

typedef NS_ENUM(NSInteger, BelssType)
{
    BelssType_None = 0,//默认订单
    BelssType_Dobless = 1,//为用户加持的订单
    BelssType_Receive = 2//收到加持的订单
};


#define TarbarHeight 49//底部tabbar高度
#define NaiviagationHeight 64//顶部naviagationBar高度

#endif
