//
//  NSDictionary+NSDictionaryExt.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//


@interface NSDictionary (Additions)

/*
 返回指定key的字符串值
 没有指定key的值，返回默认值
 */
-(NSString *)stringForKey:(NSString *)key withDefault:(NSString *)defVal;
/*
 返回指定key的float值
 没有指定key的值，返回默认值
 */
-(CGFloat)floatForKey:(NSString *)key withDefault:(CGFloat)defVal;
/*
 返回指定key的timeInterval值
 没有指定key的值，返回默认值
 */
-(NSTimeInterval)timeIntervalForKey:(NSString *)key withDefault:(NSTimeInterval)defVal;
/*
 返回指定key的int值
 没有指定key的值，返回默认值
 */
-(NSInteger)intForKey:(NSString *)key withDefault:(NSInteger)defVal;

/*
 返回指定key的long long值
 没有指定key的值，返回默认值
 */
-(long long)longLongForKey:(NSString *)key withDefault:(long long)defVal;


/*
 返回指定key的long值
 没有指定key的值，返回默认值
 */
-(long)longForKey:(NSString *)key withDefault:(long)defVal;

//url生成连接（post）
- (NSString*)queryString ;

@end
