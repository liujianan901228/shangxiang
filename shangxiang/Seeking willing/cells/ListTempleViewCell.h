//
//  ListTempleViewCell.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "BaseTableViewCell.h"

@class ListTempleViewCell;

@protocol ListTempleViewCellDelegate <NSObject>

@optional
- (void)clickCell:(ListTempleViewCell*)cell;

@end

@interface ListTempleViewCell : BaseTableViewCell

@property (nonatomic, weak) id<ListTempleViewCellDelegate> cellDelegate;

@end
