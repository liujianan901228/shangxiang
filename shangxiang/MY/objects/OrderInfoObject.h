//
//  OrderInfoObject.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/31.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderInfoObject : NSObject

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
@property (nonatomic, copy) NSString* wishDate;//时间中文
@property (nonatomic, copy) NSString* blessingser;//当前订单加持用户字符串
@property (nonatomic, copy) NSString* province;//寺庙所在省份
@property (nonatomic, copy) NSString* templeThumb;//寺庙首选图片缩略图
@property (nonatomic, copy) NSString* builddhistName;//法师名字
@property (nonatomic, copy) NSString* builddHistThumb;//法师头像缩略图
@property (nonatomic, copy) NSString* status;
@property (nonatomic, copy) NSString* wishGrade;//香火等级
@property (nonatomic, copy) NSString* builddhistId;//上香师Id
@property (nonatomic, copy) NSString* buddhadate;
@property (nonatomic, copy) NSString* expectBuddhadate;//回执时间
@property (nonatomic, strong) NSMutableArray* images;//图片列表
@property (nonatomic, assign) BOOL isRedeem;//是否还愿

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
