//
//  ResourceManager.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "ResourceManager.h"

@implementation ResourceManager
+(ResourceManager*)shareInstance
{
    static dispatch_once_t onceToken;
    static id sharedObject = nil;
    dispatch_once(&onceToken, ^{
        sharedObject = [[ResourceManager alloc] init];
    });
    return sharedObject;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(id)init
{
    self = [super init];
    if(self) {
        _resImagesCache = [[NSMutableDictionary alloc] init];
        _commonBundle = [self getCommonBundle];
        [self setStyleConfigCache];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearImageCache)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

-(void)clearImageCache
{
    [_resImagesCache removeAllObjects];
}

-(void)setStyleConfigCache
{
    NSString *plistPath=[_commonBundle pathForResource:CONFIG_PLIST_PATH ofType:@"plist"];
    _resStyleCache = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
}

-(NSBundle*)getCommonBundle
{
    NSString* filePath = [[NSBundle mainBundle] bundlePath];
    NSString* bundlePath = [NSString stringWithFormat:@"%@/%@",filePath,[SYSTEM_STYLE_COMMON_BUNDLE substringFromIndex:BUNDLE_PREFIX.length]];
    return [NSBundle bundleWithPath:bundlePath];
}
@end
