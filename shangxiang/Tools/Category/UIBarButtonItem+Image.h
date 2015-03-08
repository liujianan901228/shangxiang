//
//  UIBarButtonItem+Image.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIBarButtonItem (CustomImage)

+ (UIBarButtonItem *)rsBarButtonItemWithTitle:(NSString *)title
                                       target:(id)target
                                       action:(SEL)selector;
// 可扩展
+ (UIBarButtonItem *)rsBarButtonItemWithTitle:(NSString *)title 
                                        image:(UIImage *)image
                             heightLightImage:(UIImage *)hlImage
                                 disableImage:(UIImage *)disImage
                                       target:(id)target
                                       action:(SEL)selector;

+ (UIBarButtonItem *)rsBarButtonItemWithBellButton:(UIButton *)bellButton
                                        image:(UIImage *)image
                             heightLightImage:(UIImage *)hlImage
                                 disableImage:(UIImage *)disImage
                                       target:(id)target
                                       action:(SEL)selector;

+ (UIButton*)rsCustomBarButtonWithTitle:(NSString*)title
                                  image:(UIImage *)image
                       heightLightImage:(UIImage *)hlImage
                           disableImage:(UIImage *)disImage
                                 target:(id)target
                                 action:(SEL)selector;

- (void)setButtonAttribute:(NSDictionary*)dic;

@end

@interface UIToolbar(UIToolbar_Image)

// 设置底边条背景图片
- (void)setToolBarWithImageKey:(NSString *)imageKey;

- (void)setToolBarWithImage:(UIImage *)image;
// 清空底边条的背景图片，使恢复到系统默认状态
- (void)clearToolBarImage;


@end

