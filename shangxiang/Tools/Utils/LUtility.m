//
//  LUtility.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "LUtility.h"
#include <sys/sysctl.h>
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation LUtility
+ (BOOL)isHigherIOS6
{
    NSString *requestSysVer = @"6.0";
    NSString *currentSysVer = [[UIDevice currentDevice] systemVersion];
    
    if ([currentSysVer compare:requestSysVer options:NSNumericSearch] == NSOrderedAscending) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)isHigherIOS7
{
    NSString *requestSysVer = @"7.0";
    NSString *currentSysVer = [[UIDevice currentDevice] systemVersion];
    
    if ([currentSysVer compare:requestSysVer options:NSNumericSearch] == NSOrderedAscending) {
        return NO;
    }
    
    return YES;
}

+ (NSDictionary *)urlQueryInfo:(NSString *)query
{
    if (0 >= query.length) {
        return nil;
    }
    
    NSMutableDictionary *queryDict = [NSMutableDictionary dictionary];
    NSArray             *queries = [query componentsSeparatedByString:@"&"];
    
    for (NSString *perQuery in queries) {
        NSArray *pairOfKeyVakue = [perQuery componentsSeparatedByString:@"="];
        
        if (2 != pairOfKeyVakue.count) {
            continue;
        }
        
        [queryDict setObject:pairOfKeyVakue[1] forKey:pairOfKeyVakue[0]];
    }
    
    return queryDict;
}

+ (NSString *) machineModel{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *machineModel = [NSString stringWithUTF8String:machine];
    free(machine);
    return machineModel;
}

+ (NSString*)currentDevice
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString*)getWishTitle:(WishType)wishType
{
    NSString* result = @"健康";
    switch (wishType) {
        case WishType_Wealth:
            result = @"财富";
            break;
        case WishType_Health:
            result = @"健康";
            break;
        case WishType_Praying:
            result = @"求子";
            break;
        case WishType_Ping:
            result = @"平安";
            break;
        case WishType_Learning:
            result = @"学业";
            break;
        case WishType_Marriage:
            result = @"姻缘";
            break;
        case WishType_Career:
            result = @"事业";
            break;
        default:
            break;
    }
    return result;
}

+ (WishType)getWishType:(NSString*)wishTitle
{
    if([wishTitle isEqualToString:@"财富"])
    {
        return WishType_Wealth;
    }
    else if([wishTitle isEqualToString:@"健康"])
    {
        return WishType_Health;
    }
    else if([wishTitle isEqualToString:@"求子"])
    {
        return WishType_Praying;
    }
    else if([wishTitle isEqualToString:@"平安"])
    {
        return WishType_Ping;
    }
    else if([wishTitle isEqualToString:@"学业"])
    {
        return WishType_Learning;
    }
    else if([wishTitle isEqualToString:@"姻缘"])
    {
        return WishType_Marriage;
    }
    else if([wishTitle isEqualToString:@"事业"])
    {
        return WishType_Career;
    }
    
    return WishType_Wealth;
}


+ (NSString*)getShowName
{
    if(!USEROPERATIONHELP.currentUser.nickName || USEROPERATIONHELP.currentUser.nickName.length == 0)
    {
        if(USEROPERATIONHELP.currentUser.trueName && USEROPERATIONHELP.currentUser.trueName.length > 0)
        {
            return USEROPERATIONHELP.currentUser.trueName;
        }
        else
        {
            return @"匿名";
        }
    }
    else
    {
        return USEROPERATIONHELP.currentUser.nickName;
    }
    return @"匿名";
}


+ (NSString*)getDisCoverShowName:(NSString*)nickName trueName:(NSString*)trueName
{
    if(!nickName || nickName.length == 0)
    {
        if(trueName && trueName.length > 0)
        {
            return trueName;
        }
        else
        {
            return @"匿名";
        }
    }
    else
    {
        return nickName;
    }
    return @"匿名";
}

/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10 * 中国移动：China Mobile
     11 * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12 */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15 * 中国联通：China Unicom
     16 * 130,131,132,152,155,156,185,186
     17 */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20 * 中国电信：China Telecom
     21 * 133,1349,153,180,189
     22 */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25 * 大陆地区固话及小灵通
     26 * 区号：010,020,021,022,023,024,025,027,028,029
     27 * 号码：七位或八位
     28 */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSString*)getBuildListName:(NSInteger)month day:(NSInteger)day
{
    NSArray* buildList = [LUtility getBuildList];
    for(NSDictionary* dic in buildList)
    {
        NSInteger resultMonth = [[dic objectForKey:@"month"] integerValue];
        NSInteger resultDay = [[dic objectForKey:@"day"] integerValue];
        if(resultMonth == month && resultDay == day)
        {
            return [dic objectForKey:@"value"];
        }
    }
    return nil;
}

+ (NSArray*)getBuildList
{
    static dispatch_once_t onceToken;
    static id sharedObject = nil;
    dispatch_once(&onceToken, ^{
        sharedObject = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BuddhismHoliday" ofType:@"plist"]];
    });
    return sharedObject;
}

+ (NSString *)md5:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (NSString *)sha1:(NSString *)input
{
    const char *ptr = [input UTF8String];
    
    int i =0;
    int len = (int)strlen(ptr);
    Byte byteArray[len];
    while (i!=len)
    {
        unsigned eachChar = *(ptr + i);
        unsigned low8Bits = eachChar & 0xFF;
        
        byteArray[i] = low8Bits;
        i++;
    }
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(byteArray, len, digest);
    
    NSMutableString *hex = [NSMutableString string];
    for (int i=0; i<20; i++)
        [hex appendFormat:@"%02x", digest[i]];
    
    NSString *immutableHex = [NSString stringWithString:hex];
    
    return immutableHex;
}

+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    //NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) || (interface->ifa_flags & IFF_LOOPBACK)) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                char addrBuf[INET6_ADDRSTRLEN];
                if(inet_ntop(addr->sin_family, &addr->sin_addr, addrBuf, sizeof(addrBuf))) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, addr->sin_family == AF_INET ? IP_ADDR_IPv4 : IP_ADDR_IPv6];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    
    // The dictionary keys have the form "interface" "/" "ipv4 or ipv6"
    return [addresses count] ? addresses : nil;
}


@end
