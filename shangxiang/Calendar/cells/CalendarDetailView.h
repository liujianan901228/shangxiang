//
//  CalendarDetailView.h
//  shangxiang
//
//  Created by 刘佳男 on 15/1/21.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarDetailView : UIView
{
    @private
    UILabel *nongliLabel;
    UILabel *yangliLabel;
    UILabel *riqiLabel;
}
@property (nonatomic,strong) NSString *nongli;
@property (nonatomic,strong) NSString *yangli;
@property (nonatomic,strong) NSString *riqi;

@end
