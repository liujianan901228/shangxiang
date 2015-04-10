//
//  PayInfoViewController.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/31.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "BaseViewController.h"

@interface PayInfoViewController : BaseViewController

@property (nonatomic, copy) NSString* orderId;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, copy) NSString* productName;
@property (nonatomic, copy) NSString* orderContentText;//祈福内容

@end
