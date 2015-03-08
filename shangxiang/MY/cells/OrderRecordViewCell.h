//
//  OrderRecordViewCell.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/11.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "BaseTableViewCell.h"

@class OrderRecordViewCell;

@protocol OrderRecordViewCellDelegate <NSObject>

@optional
- (void)deleteCell:(OrderRecordViewCell*)cell;
- (void)clickCell:(OrderRecordViewCell*)cell;

@end

@interface OrderRecordViewCell : BaseTableViewCell

@property (nonatomic, weak) id<OrderRecordViewCellDelegate> cellDelegate;

@end
