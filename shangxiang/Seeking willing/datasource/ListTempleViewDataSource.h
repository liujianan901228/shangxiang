//
//  ListTempleViewDataSource.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "BaseTableViewDataSource.h"
#import "ListTempleViewCell.h"

@interface ListTempleViewDataSource : BaseTableViewDataSource

@property (nonatomic, weak) id<ListTempleViewCellDelegate> cellDelegate;

@end
