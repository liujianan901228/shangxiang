//
//  LookOrderDataSource.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/31.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "BaseTableViewDataSource.h"
#import "LookOrderViewCell.h"

@interface LookOrderDataSource : BaseTableViewDataSource

@property (nonatomic, weak) id <LookOrderDelegate> cellDelegate;

@end
