//
//  NotificationCell.h
//  shangxiang
//
//  Created by limingchen on 15/2/9.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "NotificationObject.h"

@interface NotificationCell : BaseTableViewCell

+ (CGFloat)getCellHeight:(NotificationObject*)object;

@end
