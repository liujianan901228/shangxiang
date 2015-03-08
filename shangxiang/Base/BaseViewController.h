//
//  BaseViewController.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController

-(void)unLoadViews;
-(void)goBack;
-(void)customGoBack;
#pragma mark HUD相关
- (void)showTimedHUD:(BOOL)animated message:(NSString *)message;
- (void)showTimedHUD:(BOOL)animated message:(NSString *)message hideAfter:(NSTimeInterval)time;
- (void)showChrysanthemumHUD:(BOOL)animated;
- (void)showChrysanthemumHUD:(BOOL)animated yOffset:(CGFloat)yOffset height:(CGFloat)height;
- (void)removeAllHUDViews:(BOOL)animated;

- (void)setRightBarButtonItem:(UIBarButtonItem *)barButtonItem;

- (void)setBackBarButtonItem;

- (void)dealWithError:(ExError*)error;
@end
