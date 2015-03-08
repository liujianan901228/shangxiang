//
//  ListTempleInfoViewController.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/16.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "BaseViewController.h"
#import "TempleObject.h"

@interface ListTempleInfoViewController : BaseViewController

@property (nonatomic, strong) TempleObject* templeObject;
@property (nonatomic, assign) WishType wishType;

@end
