//
//  CommonTextFiled.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/18.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CommonTextFiled : UIView

@property (nonatomic, strong) NSString* textPlaceHolder;//上面显示区域
@property (nonatomic, assign) NSInteger maxInputCount;

- (NSString*)getContentText;

- (void)insertMessage:(NSString*)message;

@end
