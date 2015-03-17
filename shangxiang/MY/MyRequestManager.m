//
//  MyRequestManager.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/23.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "MyRequestManager.h"
#import "WillingObject.h"
#import "NotificationObject.h"

@implementation MyRequestManager

//获取订单列表
+(BaseRequest*)getMemerOrderList:(NSString*)mid
                       also:(NSString*)also
                       page:(NSInteger)page
                  pageCount:(NSInteger)pageCount
               successBlock: (RequestSuccessBlock)successBlock
                     failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    BaseRequest* request = [BaseRequest sendGetRequestWithMethod:@"getmemberorderlist.php" parameters:@{@"mid":mid,@"also":also} CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            id dicArray = [info objectForKey:@"myorderlist"];
            if([dicArray isKindOfClass:[NSArray class]] && (NSArray*)dicArray && ((NSArray*)dicArray).count > 0)
            {
                for(NSDictionary* dictionary in dicArray)
                {
                    WillingObject * object = [[WillingObject alloc] initWithDic:dictionary];
                    [array addObject:object];
                }
            }
            
            
            EXECUTE_BLOCK_SAFELY(successBlockCopy,array);
        }
    }];
    return request;
}

//意见反馈
+ (BaseRequest*)postFeedBackInfo:(NSString*)mid content:(NSString*)content
                    successBlock: (RequestSuccessBlock)successBlock
                          failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    BaseRequest* request = [BaseRequest sendPostRequestWithMethod:@"addfeedbackdo.php" parameters:@{@"mid":mid,@"content":content} CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            EXECUTE_BLOCK_SAFELY(successBlockCopy,info);
        }
    }];
    return request;
}

//修改头像
+ (BaseRequest*)postUserImage:(NSString*)mid imageData:(NSData*)data
                    successBlock: (RequestSuccessBlock)successBlock
                          failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    BaseRequest* request = [BaseRequest sendPostRequestWithMethod:@"hfupload.php" parameters:@{@"uploadedfile":data,@"uploadimage":@"1",@"mid":mid} CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            EXECUTE_BLOCK_SAFELY(successBlockCopy,info);
        }
    }];
    return request;
}


//修改资料
+ (BaseRequest*)changUserInfo:(NSString*)mid nickName:(NSString*)nickName trueName:(NSString*)trueName area:(NSString*)area sex:(NSInteger)sex
                 successBlock: (RequestSuccessBlock)successBlock
                       failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    if(!mid || !nickName || !trueName || !area ) return nil;
    
    BaseRequest* request = [BaseRequest sendPostRequestWithMethod:@"modifymemberinfodo.php" parameters:@{@"mid":mid,@"nickname":nickName,@"truename":trueName,@"area":area,@"sex":@(sex)} CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            EXECUTE_BLOCK_SAFELY(successBlockCopy,info);
        }
    }];
    return request;
}


//发送资料
+ (BaseRequest*)sendMobileMessage:(NSString*)mobile
                 successBlock: (RequestSuccessBlock)successBlock
                       failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    BaseRequest* request = [BaseRequest sendPostRequestWithMethod:@"sendsmsdo.php" parameters:@{@"mobile":mobile} CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            EXECUTE_BLOCK_SAFELY(successBlockCopy,info);
        }
    }];
    return request;
}

//发送资料
+ (BaseRequest*)ResetChangeMobileMessage:(NSString*)mobile
                                password:(NSString*)password
                     successBlock: (RequestSuccessBlock)successBlock
                           failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    BaseRequest* request = [BaseRequest sendPostRequestWithMethod:@"modifypassdo.php" parameters:@{@"mobile":mobile,@"password":password} CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            EXECUTE_BLOCK_SAFELY(successBlockCopy,info);
        }
    }];
    return request;
}

//删除订单
+ (BaseRequest*)deleteOrder:(NSString*)oid successBlock: (RequestSuccessBlock)successBlock
                     failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    BaseRequest* request = [BaseRequest sendGetRequestWithMethod:@"deleteorderdo.php" parameters:@{@"oid":oid,@"mid":USEROPERATIONHELP.currentUser.userId} CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            EXECUTE_BLOCK_SAFELY(successBlockCopy,info);
        }
    }];
    return request;
}

//获取城市列表
+ (BaseRequest*)getProvinceCitys: (RequestSuccessBlock)successBlock
                          failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    BaseRequest* request = [BaseRequest sendGetRequestWithMethod:@"getprovincecitylist.php" parameters:nil CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
//            NSMutableArray* array = [NSMutableArray array];
//            
//            NSArray* infoArray = [info objectForKey:@"province_city"];
//            for(NSDictionary* dic in infoArray)
//            {
//                
//            }
            
            EXECUTE_BLOCK_SAFELY(successBlockCopy,info);
        }
    }];
    return request;
}

//获取通知
+ (BaseRequest*)getNotificationList: (RequestSuccessBlock)successBlock
                             failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    BaseRequest* request = [BaseRequest sendGetRequestWithMethod:@"getsystemmessagelist.php" parameters:nil CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            NSMutableArray* array = [NSMutableArray array];
            
            NSArray* infoArray = [info objectForKey:@"sysmsglist"];
            for(NSDictionary* dic in infoArray)
            {
                NotificationObject* object = [[NotificationObject alloc] initWithDic:dic];
                [array addObject:object];
            }
            
            EXECUTE_BLOCK_SAFELY(successBlockCopy,array);
        }
    }];
    return request;
}

//获取微信支付token
+ (BaseRequest*)getWeixinAccessToken:(NSString*)orderPrice productName:(NSString*)productName orderNo:(NSString*)orderNo
                            success: (RequestSuccessBlock)successBlock
                              failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    BaseRequest* request = [BaseRequest sendGetOtherUrl:@"http://demo123.shangxiang.com/api/app_weixinpay/index.php" parameters:nil CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            EXECUTE_BLOCK_SAFELY(successBlockCopy,info);
        }
    }];
    
    return request;
}

@end
