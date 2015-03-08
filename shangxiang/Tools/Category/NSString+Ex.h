//
//  NSString+Ex.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(URLString)

//urlencode
- (NSString*) urlEncode2:(NSStringEncoding)stringEncoding;

/**
 *  判断字符串是否为空
 *
 *  @param string 输入
 *
 *  @return 是否为空
 */
+ (BOOL)stringIsNull:(NSString *)string;

@end
