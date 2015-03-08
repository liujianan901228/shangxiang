//
//  AddBirthdayViewController.h
//  shangxiang
//
//  Created by 刘佳男 on 15/1/21.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CalendarDataSource.h"

@interface AddBirthdayViewController : BaseViewController
{
    @public
    NSInteger selectDefaultYear;
    NSInteger selectDefaultMonth;
    NSInteger selectDefaultDay;
}

@property (nonatomic,strong) NSNumber *rid;
@property (nonatomic,strong) NSString *rname;
@property (nonatomic,strong) NSString *rdate;


@end
