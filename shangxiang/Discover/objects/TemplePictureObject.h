//
//  TemplePictureObject.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/17.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemplePictureObject : NSObject

@property (nonatomic, copy) NSString* picBigUrl;
@property (nonatomic, copy) NSString* picSmallUrl;

- (instancetype)initWithDic:(NSDictionary*)dic;;

@end
