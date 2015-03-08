//
//  DiscoverManager.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/13.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "DiscoverManager.h"
#import "OrderObject.h"
#import "TempleObject.h"
#import "BlessingsMemberObject.h"
#import "OrderInfoObject.h"
#import "TemplePictureObject.h"

@implementation DiscoverManager

//获取发现列表
+(BaseRequest*)getDiscoverList:(NSString*)tid
                    pageNumber:(NSInteger)pageNumber
                   numberCount:(NSInteger)numberCount
                         bless:(BelssType)blessType
                  successBlock:(RequestSuccessBlock)successBlock
                          failed:(RequestErrorBlock)errorBlock {
    
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    if(tid)
    {
        [params setObject:tid forKey:@"tid"];
    }
    [params setObject:@(pageNumber) forKey:@"p"];
    [params setObject:@(numberCount) forKey:@"pz"];
    [params setObject:@(blessType) forKey:@"bless"];
    if(USEROPERATIONHELP.isLogin)
    {
        [params setObject:USEROPERATIONHELP.currentUser.userId forKey:@"mid"];
    }
    
    BaseRequest* request = [BaseRequest sendGetRequestWithMethod:@"getorderlist.php" parameters:params CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            NSArray* dicArray = [info objectForKey:@"orderlist"];
            for(NSDictionary* dictionary in dicArray)
            {
                OrderObject* object = [[OrderObject alloc] initWithDic:dictionary];
                [array addObject:object];
            }
            EXECUTE_BLOCK_SAFELY(successBlockCopy,array);
        }
    }];
    return request;
}

//获取寺庙列表
+(BaseRequest*)getTempleList:(RequestSuccessBlock)successBlock
                        failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    BaseRequest* request = [BaseRequest sendGetRequestWithMethod:@"getwishtemplelist.php" parameters:nil CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            NSArray* dicArray = [info objectForKey:@"wishtemplelist"];
            for(NSDictionary* dictionary in dicArray)
            {
               TempleObject * object = [[TempleObject alloc] initWithDic:dictionary];
                [array addObject:object];
            }
            EXECUTE_BLOCK_SAFELY(successBlockCopy,array);
        }
    }];
    return request;
}

//获取寺庙列表
+(BaseRequest*)getTempleList:(NSInteger)wishType
                            successBlock:(RequestSuccessBlock)successBlock
                      failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    BaseRequest* request = [BaseRequest sendGetRequestWithMethod:@"getwishtemplelist.php" parameters:@{@"wishtype":@(wishType)} CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            NSArray* dicArray = [info objectForKey:@"wishtemplelist"];
            for(NSDictionary* dictionary in dicArray)
            {
                TempleObject * object = [[TempleObject alloc] initWithDic:dictionary];
                [array addObject:object];
            }
            EXECUTE_BLOCK_SAFELY(successBlockCopy,array);
        }
    }];
    return request;
}


//获取发现详情
+(BaseRequest*)getOrderInfoByBlessNumber:(NSString*)oid
                successBlock: (RequestSuccessBlock)successBlock
                      failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    BaseRequest* request = [BaseRequest sendGetRequestWithMethod:@"getorderinfo.php" parameters:@{@"oid":oid} CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            id dicArray = [info objectForKey:@"blessings_members"];
            if([dicArray isKindOfClass:[NSArray class]] && (NSArray*)dicArray && ((NSArray*)dicArray).count > 0)
            {
                for(NSDictionary* dictionary in dicArray)
                {
                    BlessingsMemberObject * object = [[BlessingsMemberObject alloc] initWithDic:dictionary];
                    [array addObject:object];
                }
            }
            
            
            EXECUTE_BLOCK_SAFELY(successBlockCopy,array);
        }
    }];
    return request;
}


//为某一条发现加持
+ (BaseRequest*)addBlessingsdo:(NSString*)orderId userId:(NSString*)userId successBlock: (RequestSuccessBlock)successBlock
                        failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    if(!orderId || !userId)
    {
        EXECUTE_BLOCK_SAFELY(errorBlockCopy,[ExError errorWithCode:@"0" errorMessage:@"订单号为空，加持失败"]);
        return nil;
    }
    
    BaseRequest* request = [BaseRequest sendGetRequestWithMethod:@"addblessingsdo.php" parameters:@{@"oid":orderId,@"mid":userId} CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            NSString* msg = [info stringForKey:@"msg" withDefault:@""];
            EXECUTE_BLOCK_SAFELY(successBlockCopy,msg);
        }
    }];
    return request;
}


//获取订单详情
+(BaseRequest*)getOrderInfo:(NSString*)oid
               successBlock: (RequestSuccessBlock)successBlock
                     failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    BaseRequest* request = [BaseRequest sendGetRequestWithMethod:@"getorderinfo.php" parameters:@{@"oid":oid} CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg)
    {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            OrderInfoObject* orderInfoObject = [[OrderInfoObject alloc] initWithDic:[info objectForKey:@"orderinfo"]];
            //解析图片
            id dicImages = [info objectForKey:@"receipt_pic"];
            if(dicImages && [dicImages isKindOfClass:[NSArray class]])
            {
                for(NSDictionary* image in dicImages)
                {
                    TemplePictureObject* picture = [[TemplePictureObject alloc] initWithDic:image];
                    [orderInfoObject.images addObject:picture];
                }
            }
            
            EXECUTE_BLOCK_SAFELY(successBlockCopy,orderInfoObject);
        }
    }];
    return request;
}

@end
