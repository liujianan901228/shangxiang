//
//  AppMarco.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#ifndef shangxiang_AppMarco_h
#define shangxiang_AppMarco_h

#define BUNDLE_PREFIX    @"bundle://"
#define SYSTEM_STYLE_COMMON_BUNDLE @"bundle://skin_common.bundle"
#define CONFIG_PLIST_PATH    @"/styleConfig"
#define BUILD_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//友盟appKey
#define UMENG_APPKEY @"5369c50456240b534f00a335"

// 公共目录名
#define kCommonDir @"common"

#define kPersistDir @"persistDir"

#define kLastUserAccount @"lastUserAccount"

#define kSearchHistory @"searchHistory"

#define kGiftSign @"giftSign"

#define kGiftAnimation @"kGiftAnimation"

#define kDanmukuOpened @"kDanmukuOpened"

#define kApiUrlIndex @"apiUrlIndex"

#define kFirstOpenAppFlag @"FirstOpenAppFlag"

#define kUUIDForApp @"UUIDForApp"

#define PHONE_NAVIGATIONBAR_HEIGHT 44
#define PHONE_STATUSBAR_HEIGHT 20

#define MAX_IMAGE_SIZE 720

#define kSuperImageRatio 2.9 // 超长图比例 3:1
#define kSuperRatioMaxLength 1600
/*
 * 通过RGB创建UIColor
 */
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define APPDELEGATE ((AppDelegate*)[UIApplication sharedApplication].delegate)
#define USEROPERATIONHELP ([UserOperationHelper shareInstance])
#define APPNAVGATOR (USEROPERATIONHELP.appNavigator)

#define EXECUTE_BLOCK_SAFELY(block, ...) { \
if (block) {                         \
block(__VA_ARGS__);              \
}                                    \
}

#endif
