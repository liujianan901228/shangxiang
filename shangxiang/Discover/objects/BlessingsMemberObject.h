//
//  BlessingsMemberObject.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/22.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlessingsMemberObject : NSObject

@property (nonatomic, copy) NSString* retime;//订单提交时间中文格式
@property (nonatomic,assign) NSInteger timeDiff;//订单提交差距的时间
@property (nonatomic, copy) NSString* nickName;
@property (nonatomic, copy) NSString* trueName;
@property (nonatomic, copy) NSString* largeUrl;
@property (nonatomic, copy) NSString* thumbUrl;

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
