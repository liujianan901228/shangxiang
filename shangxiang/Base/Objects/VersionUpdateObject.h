//
//  VersionUpdateObject.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VersionUpdateObject : NSObject
@property(nonatomic,copy)NSString* link;
@property(nonatomic,copy)NSString* lastVersion;
@property(nonatomic)NSInteger type;
-(id)initWithDic:(NSDictionary*)dic;
@end
