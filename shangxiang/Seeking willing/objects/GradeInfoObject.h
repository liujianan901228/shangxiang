//
//  GradeInfoObject.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/18.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GradeInfoObject : NSObject

@property (nonatomic, copy) NSString* gradeName;//香烛名字
@property (nonatomic, assign) NSInteger gradeVal;//香烛等级
@property (nonatomic, copy) NSString* gradeDescription;//描述
@property (nonatomic, assign) NSInteger gradePrice;

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
