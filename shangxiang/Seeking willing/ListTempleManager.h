//
//  ListTempleManager.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListTempleManager : NSObject

//获取寺庙列表详细信息
+(BaseRequest*)getTempleInfo:(NSString*)tid
                successBlock:(RequestSuccessBlock)successBlock
                      failed:(RequestErrorBlock)errorBlock;

//获取法师详细信息
+(BaseRequest*)getAttchInfo:(NSString*)attchId
               successBlock:(RequestSuccessBlock)successBlock
                     failed:(RequestErrorBlock)errorBlock;

//获取香烛价格表
+(BaseRequest*)getGradeInfo:(RequestSuccessBlock)successBlock
                     failed:(RequestErrorBlock)errorBlock;

//获取精选类型信息
+(BaseRequest*)getChoiceInfo:(NSInteger)wishType
                successBlock:(RequestSuccessBlock)successBlock
                      failed:(RequestErrorBlock)errorBlock;


//发送订单
+(BaseRequest*)postOrderInfo:(NSInteger)wishType wishText:(NSString*)wishText  wishName:(NSString*)wishName wishGrade:(NSInteger)wishGrade buddhaDate:(NSString*)buddhaDate wishPlace:(NSString*)wishPlace tid:(NSString*)tid aid:(NSString*)aid userId:(NSString*)userId mobile:(NSString*)mobile  alsoWish:(NSInteger)alsoWish orderId:(NSString*)orderId
                successBlock:(RequestSuccessBlock)successBlock
                      failed:(RequestErrorBlock)errorBlock;

@end
