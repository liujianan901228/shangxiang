//
//  LoginRequestManager.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/11.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "LoginRequestManager.h"
#import "APService.h"

@implementation LoginRequestManager

//注册接口
+(BaseRequest*)postRegister:(NSString*)mobile andPassword:(NSString*)password success:(RequestSuccessBlock)successBlock
                          failed:(RequestErrorBlock)errorBlock {
    
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    BaseRequest* request = [BaseRequest sendPostRequestWithMethod:@"regdo.php" parameters:@{@"mobile":mobile,@"password":password,@"jregid":[APService registrationID]} CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
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

//登录接口
+(BaseRequest*)postLogin:(NSString*)mobile andPassword:(NSString*)password success:(RequestSuccessBlock)successBlock
                     failed:(RequestErrorBlock)errorBlock {
    
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    BaseRequest* request = [BaseRequest sendPostRequestWithMethod:@"logindo.php" parameters:@{@"mobile":mobile,@"password":password,@"jregid":[APService registrationID]} CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
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

//获取用户信息
+(BaseRequest*)sendGetUserInfo:(NSString*)userId success:(RequestSuccessBlock)successBlock
                             failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    NSDictionary* params = @{@"mid":userId};
    
    BaseRequest* request = [BaseRequest sendGetRequestWithMethod:@"getmemberinfo.php" parameters:params CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            AppUser* user = [[AppUser alloc] initWithDic:[info objectForKey:@"memberinfo"]];
            USEROPERATIONHELP.currentUser = user;
            USEROPERATIONHELP.currentUser.isLogined = YES;
            
            [UserGlobalSetting setCurrentUser:USEROPERATIONHELP.currentUser];
            EXECUTE_BLOCK_SAFELY(successBlockCopy,info);
        }
    }];
    return request;
}

//获取微博用户信息
+(BaseRequest*)sendGetWeiboUserInfo:(NSString*)userId token:(NSString*)token success:(RequestSuccessBlock)successBlock
                     failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    NSDictionary* params = @{@"source":KAllAPPKey,@"access_token":token,@"uid":userId};
    
    BaseRequest* request = [BaseRequest sendGetOtherUrl:@"https://api.weibo.com/2/users/show.json" parameters:params CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            NSString* userId = [info stringForKey:@"id" withDefault:@""];
            NSString* nickName = [info stringForKey:@"screen_name" withDefault:@""];
            NSString* headUrl = [info stringForKey:@"avatar_hd" withDefault:@""];
            [LoginRequestManager sendThirdLogin:token name:userId regtype:@"sina" headUrl:headUrl nickName:nickName success:^(id obj) {
                
            } failed:^(id error) {
                
            }];
            EXECUTE_BLOCK_SAFELY(successBlockCopy,nil);
        }
    }];
    return request;
}



//获取微信token
+(BaseRequest*)sendGetWeiXinToken:(NSString*)code success:(RequestSuccessBlock)successBlock
                             failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    NSDictionary* params = @{@"appid":KWeixinAppKey,@"secret":KWeixinAppSecret,@"code":code,@"grant_type":@"authorization_code"};
    
    BaseRequest* request = [BaseRequest sendGetOtherUrl:@"https://api.weixin.qq.com/sns/oauth2/access_token" parameters:params CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
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


//获取微信userInfo
+(BaseRequest*)sendGetWeiXinInfo:(NSString*)token openId:(NSString*)openId success:(RequestSuccessBlock)successBlock
                           failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    NSDictionary* params = @{@"access_token":token,@"openid":openId};
    
    BaseRequest* request = [BaseRequest sendGetOtherUrl:@"https://api.weixin.qq.com/sns/userinfo" parameters:params CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            NSString* headimgurl = [info stringForKey:@"headimgurl" withDefault:@""];
            NSString* nickname = [info stringForKey:@"nickname" withDefault:@""];
            [LoginRequestManager sendThirdLogin:token name:openId regtype:@"wx" headUrl:headimgurl nickName:nickname success:^(id obj) {
                
            } failed:^(id error) {
                
            }];
            EXECUTE_BLOCK_SAFELY(successBlockCopy,nil);
        }
    }];
    return request;
}

//第三方登陆
+(BaseRequest*)sendThirdLogin:(NSString*)token name:(NSString*)name regtype:(NSString*)regtype headUrl:(NSString*)headUrl nickName:(NSString*)nickName success:(RequestSuccessBlock)successBlock
                          failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    NSDictionary* params = @{@"token":token,@"name":name,@"regtype":regtype,@"hf":headUrl,@"nname":nickName,@"jregid":[APService registrationID]};
    BaseRequest* request = [BaseRequest sendPostRequestWithMethod:@"ologindo.php" parameters:params CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            id member = [info objectForKey:@"memberinfo"];
            if([member isKindOfClass:[NSString class]]) return;

            if(!USEROPERATIONHELP.currentUser)
            {
                AppUser* user = [[AppUser alloc] initWithDic:[info objectForKey:@"memberinfo"]];
                USEROPERATIONHELP.currentUser = user;
                USEROPERATIONHELP.currentUser.isLogined = YES;
            }
            [UserGlobalSetting setCurrentUser:USEROPERATIONHELP.currentUser];
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:AppUserLoginNotification object:nil];
            EXECUTE_BLOCK_SAFELY(successBlockCopy,info);
        }
    }];
    return request;
}


@end
