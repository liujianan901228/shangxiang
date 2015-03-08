//
//  DiscoverViewCell.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/13.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DiscoverPopViewDataSource.h"

@class OrderObject;
@class DiscoverViewCell;

@protocol DiscoverDelegate <NSObject>

@optional
- (void)didClickAddBelss:(DiscoverViewCell*)cell;

@end

@interface DiscoverViewCell : BaseTableViewCell

@property (nonatomic, weak) id <DiscoverDelegate> cellDelegate;

+ (CGFloat)getDiscoverHeight:(OrderObject*)object;

- (void)setBlessSuccess;

@end
