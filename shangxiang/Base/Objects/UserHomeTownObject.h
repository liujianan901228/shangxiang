//
//  UserHomeTownObject.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface UserHomeTownObject : NSObject
@property (nonatomic, strong) NSString* city;//东郊区。。。。
@property (nonatomic, strong) NSString* provinceValue;//北京市
@property (nonatomic, strong) NSString* provinceName;//北京

-(NSString *)transHomeToString;
@end
