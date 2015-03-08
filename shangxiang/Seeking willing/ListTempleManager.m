//
//  ListTempleManager.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "ListTempleManager.h"
#import "TempleInfoObject.h"
#import "AttachInfoObject.h"
#import "GradeInfoObject.h"

@implementation ListTempleManager


//获取寺庙列表详细信息
+(BaseRequest*)getTempleInfo:(NSString*)tid
                successBlock:(RequestSuccessBlock)successBlock
                          failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    BaseRequest* request = [BaseRequest sendGetRequestWithMethod:@"gettempleinfo.php" parameters:@{@"tid":tid} CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            TempleInfoObject* infoObject = [[TempleInfoObject alloc] initWithDic:[info objectForKey:@"templeinfo"]];
            EXECUTE_BLOCK_SAFELY(successBlockCopy,infoObject);
        }
    }];
    return request;
}

//获取法师详细信息
+(BaseRequest*)getAttchInfo:(NSString*)attchId
                successBlock:(RequestSuccessBlock)successBlock
                      failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    BaseRequest* request = [BaseRequest sendGetRequestWithMethod:@"getattacheinfo.php" parameters:@{@"aid":attchId} CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            NSDictionary* attcheinfo = [info objectForKey:@"attacheinfo"];
            AttachInfoObject* infoObject = [[AttachInfoObject alloc] initWithDic:attcheinfo];
            EXECUTE_BLOCK_SAFELY(successBlockCopy,infoObject);
        }
    }];
    return request;
}


//获取香烛价格表
+(BaseRequest*)getGradeInfo:(RequestSuccessBlock)successBlock
                     failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    BaseRequest* request = [BaseRequest sendGetRequestWithMethod:@"getwishgradeinfo.php" parameters:nil CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg)
    {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            NSMutableArray* result = [NSMutableArray array];
            
            NSArray* array = [info objectForKey:@"wishgradeinfo"];
            
            for(NSDictionary* dic in array)
            {
                GradeInfoObject* infoObject = [[GradeInfoObject alloc] initWithDic:dic];
                [result addObject:infoObject];
            }
            
            EXECUTE_BLOCK_SAFELY(successBlockCopy,result);
        }
    }];
    return request;
}

//获取精选类型信息
+(BaseRequest*)getChoiceInfo:(NSInteger)wishType
                    successBlock:(RequestSuccessBlock)successBlock
                     failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    
    BaseRequest* request = [BaseRequest sendGetRequestWithMethod:@"getwishtextchoice.php" parameters:@{@"wishtype":@(wishType)} CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg)
    {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            NSArray* array = [info objectForKey:@"wishtextchoice"];
            EXECUTE_BLOCK_SAFELY(successBlockCopy,array);
        }
    }];
    return request;
}


//发送订单
+(BaseRequest*)postOrderInfo:(NSInteger)wishType wishText:(NSString*)wishText  wishName:(NSString*)wishName wishGrade:(NSInteger)wishGrade buddhaDate:(NSString*)buddhaDate wishPlace:(NSString*)wishPlace tid:(NSString*)tid aid:(NSString*)aid userId:(NSString*)userId mobile:(NSString*)mobile  alsoWish:(NSInteger)alsoWish orderId:(NSString*)orderId
                successBlock:(RequestSuccessBlock)successBlock
                      failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:@(wishType) forKey:@"wishtype"];
    [dic setObject:wishText forKey:@"wishtext"];
    [dic setObject:wishName forKey:@"wishname"];
    [dic setObject:@(wishGrade) forKey:@"wishgrade"];
    [dic setObject:buddhaDate forKey:@"buddhadate"];
    [dic setObject:wishPlace forKey:@"wishplace"];
    [dic setObject:tid forKey:@"tid"];
    [dic setObject:aid forKey:@"aid"];
    [dic setObject:userId forKey:@"mid"];
    if(mobile) [dic setObject:mobile forKey:@"mobile"];
    [dic setObject:@(alsoWish) forKey:@"alsowish"];
    if(orderId) [dic setObject:orderId forKey:@"vorderid"];
    
    
    BaseRequest* request = [BaseRequest sendPostRequestWithMethod:@"addorderdo.php" parameters:dic CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
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
