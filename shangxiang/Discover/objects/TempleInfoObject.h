//
//  TempleInfoObject.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/16.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TempleInfoObject : NSObject

@property (nonatomic, copy) NSString* templeId;//寺庙Id
@property (nonatomic, copy) NSString* templeName;//寺庙名称
@property (nonatomic, copy) NSString* templeDescription;//寺庙简介
@property (nonatomic, copy) NSString* templeBuildTime;//简历时间
@property (nonatomic, copy) NSString* templeProvince;//寺庙省份
@property (nonatomic, assign) NSInteger orderCount;//寺庙订单数
@property (nonatomic, strong) NSMutableArray* images;//图片数组

- (instancetype)initWithDic:(NSDictionary*)dic;

- (NSString*)getFirstBigUrl;

- (NSString*)getFirstSmallUrl;

@end
