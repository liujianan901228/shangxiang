//
//  NotificationObject.h
//  shangxiang
//
//  Created by limingchen on 15/2/9.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationObject : NSObject

@property (nonatomic, copy) NSString* notifyId;
@property (nonatomic, copy) NSString* title;
@property (nonatomic,copy) NSString* time;

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
