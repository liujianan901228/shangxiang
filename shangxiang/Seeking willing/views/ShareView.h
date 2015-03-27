//
//  ShareView.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/31.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WxType)
{
    WxType_Friend = 0 ,
    WxType_Single = 1 ,
    WxType_Weibo = 2
};

typedef void(^ShareBlock)(WxType type, NSString* shareText);

@interface ShareView : UIView

@property (nonatomic, copy) ShareBlock shareBlock;
@property (nonatomic, strong) UITextView* textView;

- (void)showInWindow:(UIWindow*)window orderText:(NSString*)orderText;
- (void)close;

@end
