//
//  AttachInfoObject.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/17.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttachInfoObject : NSObject

@property (nonatomic, copy) NSString* attacheId;//上香师Id
@property (nonatomic, copy) NSString* buddhistName;//法号
@property (nonatomic, copy) NSString* attacheName;//上香师名字
@property (nonatomic, copy) NSString* age;//年龄
@property (nonatomic, copy) NSString* conversion;//皈依时间
@property (nonatomic, copy) NSString* headBigUrl;//头像
@property (nonatomic, copy) NSString* headSmallUrl;//头像
@property (nonatomic, copy) NSString* templeName;//所属寺庙名称
@property (nonatomic, copy) NSString* attacheDescription;//寺庙介绍

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
