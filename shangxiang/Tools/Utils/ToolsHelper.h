//
//  ToolsHelper.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserHomeTownObject.h"

@interface ToolsHelper : NSObject

+(instancetype)shareInstance;

@property(nonatomic,strong)NSArray* provinces;

@property(nonatomic,strong)NSMutableDictionary* homeTownMap;


+ (CGSize)calculateSize:(NSString *)content maxWidth:(CGFloat)textlabelMaxWidth fontSize:(CGFloat)fontSize;

// App Document 路径
+ (NSString *)documentPath;

//写入用户信息
+(BOOL)setObjectToFile:(NSObject *)value forKey:(NSString *)key userId:(long long)userId;

//从文件中取得用户信息
+(NSObject *)objectInFileForKey:(NSString *)key userId:(long long)userId;

+ (NSString *)persistFileDir;


+ (NSString*)shortPrice:(long long)price;

+ (NSInteger)stringLen:(NSString*)string;

-(NSString*)getCurrentSystem;

-(NSString*)getCurrentDevice;

+ (NSString*) shortString:(NSString*)string length:(NSInteger)length;

+ (CGSize)calculateSize:(NSString *)content containSize:(CGSize)size fontSize:(CGFloat)fontSize;

+ (CGFloat)calculateSingleLineHeight:(CGFloat)fontSize;

@end
