//
//  AppDelegate.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginRequestManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APService.h"


@interface AppDelegate ()<WeiboSDKDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray* alertViewArray;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //向微信注册
    [WXApi registerApp:KWeixinAppKey withDescription:@"com.app.shangxiang"];
    //向微博注册
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    //接受push
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];
    
    [[AppStartup shareInstance] startUp];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];// 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [APPNAVGATOR openDefaultMainViewController];
    

    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                             NSLog(@"result = %@",resultDic);
                                         }];
        return YES;
    }
    return ([WeiboSDK handleOpenURL:url delegate:self]
            || [WXApi handleOpenURL:url delegate:self]
            );

}


#pragma WeiXin
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *temp = (SendAuthResp*)resp;
        
        if(temp && temp.code)
        {
            NSString* code = temp.code;
            [LoginRequestManager sendGetWeiXinToken:code success:^(id obj) {
                NSString* accessToken = [obj stringForKey:@"access_token" withDefault:@""];
                if(!accessToken || accessToken.length == 0) return;
                NSString* openId = [obj stringForKey:@"openid" withDefault:@""];
                if(!openId || openId.length == 0) return;
                [LoginRequestManager sendGetWeiXinInfo:accessToken openId:openId success:^(id obj) {
                   
                } failed:^(id error) {
                    
                }];
            } failed:^(id error) {
                
            }];
        }
    }
    else if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        SendMessageToWXResp *temp = (SendMessageToWXResp*)resp;
        if(temp.errCode == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:ShareSuccessNotification object:nil];
        }
    }
}





#pragma Weibo
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {
        
    }
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = @"发送结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        if(response.statusCode == 0) {
            
            NSDate* date = [(WBAuthorizeResponse*)response expirationDate];
            NSInteger timeStamp = (NSInteger)[date timeIntervalSinceNow];
            
            NSMutableDictionary* dic = [NSMutableDictionary dictionary];
            [dic setObject:self.wbtoken forKey:@"access_token"];
            [dic setObject:[NSNumber numberWithInteger:timeStamp] forKey:@"expires_in"];
            [dic setObject:[(WBAuthorizeResponse *)response userID] forKey:@"uid"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:WebLoginNotification object:dic];
        } else {
            
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [APService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
    if(application.applicationState == UIApplicationStateActive)
    {
    
        if(!_alertViewArray) _alertViewArray = [[NSMutableArray alloc] init];
        
        if(_alertViewArray.count > 0)
        {
            for(UIAlertView* alerView in _alertViewArray)
            {
                [alerView dismissWithClickedButtonIndex:[alerView cancelButtonIndex] animated:YES];
            }
            [_alertViewArray removeAllObjects];
        }
        
        NSInteger msgtype = [userInfo intForKey:@"msgtype" withDefault:3];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"您收到一条消息" message:nil delegate:self cancelButtonTitle:@"算了" otherButtonTitles:@"去看看", nil];
        [alertView setAssociateValue:@(msgtype) withKey:@"msgtype"];
        [_alertViewArray addObject:alertView];
        [alertView show];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSInteger msgtype = [[alertView getAssociatedValueForKey:@"msgtype"] integerValue];
        if(msgtype == 1 || msgtype == 2)
        {
            [APPNAVGATOR switchToLivingTab:2];
        }
        else if(msgtype == 3)
        {
            [APPNAVGATOR switchToLivingTab:0];
        }
    }
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

@end
