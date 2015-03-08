//
//  OrderObject.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/13.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//  订单

#import <Foundation/Foundation.h>

@interface OrderObject : NSObject

@property (nonatomic,copy) NSString* orderId;//订单Id
@property (nonatomic,copy) NSString* orderLongId;//长订单Id
@property (nonatomic,copy)NSString* wishType;//祈福类型
@property (nonatomic,copy) NSString* tid;//寺庙Id
@property (nonatomic,copy) NSString* alsoWish;//求愿  还愿
@property (nonatomic,assign) NSInteger retime;//订单提交时间
@property (nonatomic,copy) NSString* wishName;//祈福人姓名
@property (nonatomic,copy) NSString* wishText;//祈福内容
@property (nonatomic,assign) NSInteger timeDiff;//订单提交差距的时间
@property (nonatomic,copy) NSString* nickName;//用户昵称
@property (nonatomic,copy) NSString* trueName;//真实姓名
@property (nonatomic,copy) NSString* headUrl;//用户头像
@property (nonatomic,assign) NSInteger coBlessings;//订单加持人数
@property (nonatomic,copy) NSString* nameBelssings;//加持用户名称
@property (nonatomic,copy) NSString* templeName;//寺庙名称
@property (nonatomic,copy) NSString*bleuser;//该ID返回代表加持了  否则没有加持
@property (nonatomic,assign) BOOL isBelss;//是否加持
@property (nonatomic,copy) NSString* wishDate;//1天前。。。


- (instancetype)initWithDic:(NSDictionary*)dic;

@end
