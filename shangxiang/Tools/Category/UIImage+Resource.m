//
//  UIImage+Resource.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "UIImage+Resource.h"
#import "ResourceManager.h"

@implementation UIImage(Resource)

+(UIImage*)imageForKey:(NSString *)key
{
    if (key == nil) return nil;
    
    UIImage* image = [ResourceManager shareInstance].resImagesCache[key];
    if(!image) {
        image = [UIImage imageForKey:key inBundle:[ResourceManager shareInstance].commonBundle];
        if(image) {
            [[ResourceManager shareInstance].resImagesCache setObject:image forKey:key];
        }
    }
    return image;
}

+ (UIImage *)imageForKey:(id)key inBundle:(NSBundle *)bundle
{
    NSString *imagePath = [bundle pathForScaledResource:key ofType:@"png" inDirectory:@"Images"];
    if (imagePath) {
        return [UIImage imageWithContentsOfFile:imagePath];
    } else
    {
        imagePath = [bundle pathForResource:key ofType:@"png" inDirectory:@"Images/emotions"];
        if(imagePath) {
            return [UIImage imageWithContentsOfFile:imagePath];
        }
    }
    imagePath = [bundle pathForResource:key ofType:@"jpg" inDirectory:@"Images"];
    if (imagePath) {
        return [UIImage imageWithContentsOfFile:imagePath];
    }
    
    if ( [key isKindOfClass:[NSString class]] ) {
        NSString *key2x = [key stringByAppendingString:@"@2x"];
        if ( [bundle pathForResource:key2x ofType:@"png"]
            || [bundle pathForResource:key2x ofType:@"jpg"] ) {
            NSLog(@"ERROR: No 1x image resource (low resolution) provided for key:%@, only have 2x image.",key);
        }
    }
    return nil;
}

@end
