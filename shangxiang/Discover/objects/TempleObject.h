//
//  TempleObject.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/15.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TempleObject : NSObject

@property (nonatomic, copy) NSString* templeId;//寺庙ID
@property (nonatomic, copy) NSString* templeProvince;//寺庙省份
@property (nonatomic, copy) NSString* templeName;//寺庙名称
@property (nonatomic, copy) NSString* templeBigUrl;//寺庙图片
@property (nonatomic, copy) NSString* templeSmallUrl;//寺庙图片
@property (nonatomic, copy) NSString* attacheId;//上香师傅ID
@property (nonatomic, copy) NSString* buddhistName;//法号
@property (nonatomic, copy) NSString* attacheName;//上香师傅名字
@property (nonatomic, copy) NSString* attacheBigUrl;//上香师傅url
@property (nonatomic, copy) NSString* attacheSmallUrl;//上香师傅url
@property (nonatomic, assign) NSInteger recommendSort;//推荐顺序

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
