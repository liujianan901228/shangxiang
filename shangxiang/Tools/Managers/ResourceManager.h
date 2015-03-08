//
//  ResourceManager.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceManager : NSObject
@property(nonatomic,strong)NSMutableDictionary* resImagesCache;
@property(nonatomic,strong)NSMutableDictionary* resStyleCache;
@property(nonatomic,strong)NSBundle* commonBundle;
+(ResourceManager*)shareInstance;

@end
