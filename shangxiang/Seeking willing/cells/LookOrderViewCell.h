//
//  LookOrderViewCell.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/31.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "OrderInfoObject.h"

@class LookOrderViewCell;

@protocol LookOrderDelegate <NSObject>

@optional
- (void)shareText:(LookOrderViewCell*)cell;

@end

@interface LookOrderViewCell : BaseTableViewCell

@property (nonatomic, weak) id <LookOrderDelegate> cellDelegate;
+ (CGFloat)getCellHeight:(OrderInfoObject*)orderInfoObject;

@end
