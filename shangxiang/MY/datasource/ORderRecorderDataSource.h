//
//  ORderRecorderDataSource.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/11.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "BaseTableViewDataSource.h"
#import "OrderRecordViewCell.h"

@interface ORderRecorderDataSource : BaseTableViewDataSource

@property (nonatomic, weak) id<OrderRecordViewCellDelegate> cellDelegate;

-(void)loadData:(RefreshTableViewDataBlock)refreshDataBlock;

@end
