//
//  ToolsHelper.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "ToolsHelper.h"

@interface ToolsHelper()
@property(nonatomic,copy)NSString* currentDevice;
@property(nonatomic,copy)NSString* currentSystem;
@end

@implementation ToolsHelper

+(instancetype)shareInstance
{
    static ToolsHelper* helpers = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helpers = [[ToolsHelper alloc] init];
    });
    return helpers;
}

-(id)init
{
    self = [super init];
    if(self) {
        self.provinces =[[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hometown" ofType:@"plist"]];
        self.homeTownMap = [NSMutableDictionary dictionary];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearHomeTownDataMap)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)clearHomeTownDataMap
{
    [self.homeTownMap removeAllObjects];
}

+ (CGSize)calculateSize:(NSString *)content maxWidth:(CGFloat)textlabelMaxWidth fontSize:(CGFloat)fontSize
{

    if ([ToolsHelper stringIsEmpty:content]) {
        return CGSizeZero;
    }
    CGSize labelSize ;
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    

//#else
    if([LUtility isHigherIOS7]) {
        NSDictionary* tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize], NSFontAttributeName, nil];
        CGRect rect = [content boundingRectWithSize:CGSizeMake(textlabelMaxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil];
        labelSize = rect.size;
    } else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        labelSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(textlabelMaxWidth,CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    }
//#endif
    return labelSize;
}

+ (CGSize)calculateSize:(NSString *)content containSize:(CGSize)size fontSize:(CGFloat)fontSize
{
    
    if ([ToolsHelper stringIsEmpty:content]) {
        return CGSizeZero;
    }
    CGSize labelSize ;
    //#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    
    //#else
    if([LUtility isHigherIOS7]) {
        NSDictionary* tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize], NSFontAttributeName, nil];
        CGRect rect = [content boundingRectWithSize:CGSizeMake(size.width, size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil];
        labelSize = rect.size;
    } else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        labelSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(size.width,size.height) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    }
    //#endif
    return labelSize;
}

+ (CGFloat)calculateSingleLineHeight:(CGFloat)fontSize {
    return [ToolsHelper calculateSize:@"text" maxWidth:CGFLOAT_MAX fontSize:fontSize].height;
}

// App Document 路径
+ (NSString *)documentPath
{
    NSArray  *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [searchPath objectAtIndex:0];
    
    return path;
}

// 公共文件夹路径
+ (NSString *)commonPath
{
    NSString *path = [[ToolsHelper documentPath] stringByAppendingPathComponent:kCommonDir];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if (![fileMgr fileExistsAtPath:path]) {
        NSError *error = nil;
        [fileMgr  createDirectoryAtPath:path
            withIntermediateDirectories:YES
                             attributes:nil
                                  error:&error];
        
        if (error) {
            //            LOG_INFO(@"创建 commonPath 失败 %@", error);
        }
    }
    
    return path;
}

//向文件中写入用户信息
+ (BOOL)setObjectToFile:(NSObject *)value forKey:(NSString *)key userId:(long long)userId {
    
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:[ToolsHelper persistFileDir] withIntermediateDirectories:YES attributes:nil error:&error]) {
        return NO;
    }
    return [NSKeyedArchiver archiveRootObject:value toFile:[ToolsHelper dataFilePathForKey:key userId:userId]];
}

//从文件中取得用户信息
+(NSObject *)objectInFileForKey:(NSString *)key userId:(long long)userId
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[ToolsHelper dataFilePathForKey:key userId:userId]];
}

+ (NSString *)dataFilePathForKey:(NSString *)key userId:(long long)userId {
    NSString *documentDirectory = [ToolsHelper documentPath];
    NSString *dir = [NSString stringWithFormat:@"%@/%@/User_persistence_%@_object_%@", documentDirectory, kPersistDir,
                     [NSString stringWithFormat:@"%lld",userId], key];
    return dir;
}

+ (NSString *)persistFileDir {
    NSString *documentDirectory = [ToolsHelper documentPath];
    NSString *dir = [documentDirectory stringByAppendingPathComponent:kPersistDir];
    return dir;
}

+ (BOOL) stringIsEmpty:(NSString *) aString {
    
    if ((NSNull *) aString == [NSNull null]) {
        return YES;
    }
    
    //    if([aString isEqualToString:@"(null)"])
    //    {
    //        return YES;
    //    }
    
    if (aString == nil) {
        return YES;
    } else if ([aString length] == 0) {
        return YES;
    } else {
        aString = [aString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([aString length] == 0) {
            return YES;
        }
    }
    
    return NO;
}

+ (NSString*)shortPrice:(long long)price {
    if(price >= 100000000L) {

        if(price % 100000000L != 0) {
            double value = (double)price / 100000000L;
            return [NSString stringWithFormat:@"%.1f亿", value];
        }
        else
            return [NSString stringWithFormat:@"%lld亿", price / 100000000L];
    }
    else if(price >= (10000*1000)) {
        if(price % 10000*1000 != 0) {
            double value = (double)price / (10000*1000);
            return [NSString stringWithFormat:@"%.1f千万", value];
        }
        else
            return [NSString stringWithFormat:@"%lld千万", price / (10000*1000)];
    }
    else if(price >= 10000) {
        if(price % 10000 != 0) {
            double value = (double)price / 10000;
            return [NSString stringWithFormat:@"%.1f万", value];
        }
        else
            return [NSString stringWithFormat:@"%lld万", price / 10000];
    }
    else {
        return [NSString stringWithFormat:@"%lld", price];
    }
}

+ (NSInteger)stringLen:(NSString*)string {
    CGFloat len = 0.0f;
    
    for (int i=0; i<string.length; i++) {
       if([string characterAtIndex:i]>=32 && [string characterAtIndex:i]<=126)
           len+=0.5;
        else
            len+= 1;
    }
    
    return len;
}

+ (NSString*) shortString:(NSString*)string length:(NSInteger)length {
    
    if(string == nil) return @"";
    if([string length] == 0) return @"";
    
    CGFloat len = 0.0f;
    int index = 0;
    
    for (index=0; index<string.length; index++) {
        if([string characterAtIndex:index]>=32 && [string characterAtIndex:index]<=126)
            len+=0.5;
        else
            len+= 1;
        
        if(len >= (CGFloat)length)
            break;
    }
    
    if(index < (((int)[string length])-1))
        return [NSString stringWithFormat:@"%@...", [string substringToIndex:index] ];
    else
        return string;
}

-(NSString*)getCurrentSystem
{
    if(!self.currentSystem)
    {
        self.currentSystem = [LUtility machineModel];
    }
    return self.currentSystem;
}

-(NSString*)getCurrentDevice
{
    if(!self.currentDevice) {
        self.currentDevice = [LUtility currentDevice];
    }
    return self.currentDevice;
}

@end
