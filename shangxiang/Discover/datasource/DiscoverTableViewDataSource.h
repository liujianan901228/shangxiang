//
//  DiscoverTableViewDataSource.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/13.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "BaseTableViewDataSource.h"
#import "DiscoverViewCell.h"

@interface DiscoverTableViewDataSource : BaseTableViewDataSource

@property (nonatomic, weak) id <DiscoverDelegate> delegate;

@end
