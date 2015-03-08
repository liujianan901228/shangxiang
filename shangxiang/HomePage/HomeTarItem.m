//
//  HomeTarItem.m
//  shangxiang
//
//  Created by 倾慕 on 15/2/3.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "HomeTarItem.h"
#import "YYGestureRecognizer.h"

@implementation HomeTarItem

-(void)renderItem:(UIImage*)image SelectImage:(UIImage*)selectedImage
{
    UIImage* selected = selectedImage;
    if([LUtility isHigherIOS7])
    {
        selected = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    [self setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    [self setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName,UIColorFromRGB(COLOR_FONT_HIGHLIGHT),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [self setImage:image];
    [self setSelectedImage:selected];
}


@end
