//
//  BaseTableViewController.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController

#pragma mark HUD相关
- (void)showTimedHUD:(BOOL)animated message:(NSString *)message;
- (void)showChrysanthemumHUD:(BOOL)animated;
- (void)showChrysanthemumHUD:(BOOL)animated yOffset:(CGFloat)yOffset height:(CGFloat)height;
- (void)removeAllHUDViews:(BOOL)animated;
- (void)setRightBarButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)setLeftBarButtonItem:(UIBarButtonItem *)barButtonItem;
@end
