//
//  NSDictionary+NSDictionaryExt.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "NSDictionary+NSDictionaryExt.h"
#import "NSString+Ex.h"

@implementation NSDictionary (Additions)

-(NSString *)stringForKey:(NSString *)key withDefault:(NSString *)defVal{
    
    NSString* str = [[self allKeys] containsObject:key] ? [self objectForKey:key] : defVal;
    if((NSNull *) str == [NSNull null]) {
        str = defVal;
    }
    return str;
}

-(CGFloat)floatForKey:(NSString *)key withDefault:(CGFloat)defVal{
    @try {
        return [[self objectForKey:key] floatValue];
    }
    @catch (NSException *exception) {
        return defVal;
    }
}

-(NSTimeInterval)timeIntervalForKey:(NSString *)key withDefault:(NSTimeInterval)defVal{
    @try {
        return [[self objectForKey:key] doubleValue];
    }
    @catch (NSException *exception) {
        return defVal;
    }
}

-(NSInteger)intForKey:(NSString *)key withDefault:(NSInteger)defVal{
    @try {
        return [[self objectForKey:key] intValue];
    }
    @catch (NSException *exception) {
        return defVal;
    }
}

-(long long)longLongForKey:(NSString *)key withDefault:(long long)defVal{
    @try {
        return [[self objectForKey:key] longLongValue];
    }
    @catch (NSException *exception) {
        return defVal;
    }
}

-(long)longForKey:(NSString *)key withDefault:(long)defVal{
    @try {
        return [[self objectForKey:key] longValue];
    }
    @catch (NSException *exception) {
        return defVal;
    }
}

- (NSString*)queryString
{
    NSMutableString* buffer = [[NSMutableString alloc] initWithCapacity:0];
    for (id key in self)
    {
        NSString* value = [NSString stringWithFormat:@"%@",[self objectForKey:key]];
        value = [value urlEncode2:NSUTF8StringEncoding];
        [buffer appendString:[NSString stringWithFormat:@"&%@=%@", key, value]];
    }
    NSString* ret = [buffer substringFromIndex:1];
    
    return ret;
}


@end
