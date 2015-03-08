//
//  UIImage+GIF.m
//  LBGIFImage
//
//  Created by Laurin Brandner on 06.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImage+GIF.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (GIF)

+ (UIImage *)sd_animatedGIFWithData:(NSData *)data {
    YYGIFImage *img = [YYGIFImage imageWithData:data scale:[UIScreen mainScreen].scale];
    return img;
}

+ (UIImage *)sd_animatedGIFNamed:(NSString *)name {
    YYGIFImage *img = [YYGIFImage imageNamed:name];
    return img;
}

@end
