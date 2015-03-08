//
//  UserHomeTownObject.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//


#import "UserHomeTownObject.h"

@implementation UserHomeTownObject

- (id) initWithDictionary:(NSDictionary *)dict {
    self = [self init];
    if (self) {
        [self setValueFromDictionary:dict];
    }
    return  self;
}

- (void) setValueFromDictionary:(NSDictionary *)dict {

    self.city = [dict valueForKey:@"city"];
    self.provinceValue = [dict valueForKey:@"provinceValue"];
    self.provinceName = [dict valueForKey:@"provinceName"];

}
-(NSString *)transHomeToString{
    if ([self.provinceName isEqualToString:@""]&&[self.city isEqualToString:@""]) {
        return  @"";
    }else{
    return [NSString stringWithFormat:@"%@  %@",self.provinceName,self.city];
    }
}

@end
