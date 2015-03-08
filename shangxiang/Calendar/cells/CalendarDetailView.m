//
//  CalendarDetailView.m
//  shangxiang
//
//  Created by 刘佳男 on 15/1/21.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "CalendarDetailView.h"

@implementation CalendarDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        nongliLabel = [[UILabel alloc] init];
        yangliLabel = [[UILabel alloc] init];
        riqiLabel = [[UILabel alloc] init];
        
        [self layoutSubviews];
        [self attributeSubviews];
        
        [self addSubview:nongliLabel];
        [self addSubview:yangliLabel];
        [self addSubview:riqiLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    riqiLabel.frame = CGRectMake(0, 2, self.size.width/4., self.size.height);
    yangliLabel.frame = CGRectMake(riqiLabel.frame.size.width, 6, self.size.width*3/4., self.size.height/2.);
    nongliLabel.frame = CGRectMake(riqiLabel.frame.size.width, self.size.height/2. - 3, self.size.width*3/4., self.size.height/2.);
    

    
}

- (void)attributeSubviews
{
    riqiLabel.textColor = [UIColor colorWithRed:217/256. green:147/256. blue:67/256. alpha:1];
    riqiLabel.textAlignment = NSTextAlignmentCenter;
    UIFont *font = [UIFont systemFontOfSize:35.];
    riqiLabel.font = font;
    
    font = [UIFont systemFontOfSize:13];
    yangliLabel.font = font;
    nongliLabel.font = font;
    yangliLabel.textColor = [UIColor colorWithRed:90./255. green:90./255. blue:90./255. alpha:1];
    nongliLabel.textColor = [UIColor colorWithRed:90./255. green:90./255. blue:90./255. alpha:1];
}

- (void)setYangli:(NSString *)yangli
{
    NSString *temp;
    
    if ([yangli containsString:@"Sun"] || [yangli containsString:@"周日"]) {
        temp = @"星期日";
    }
    else if([yangli containsString:@"Mon"] || [yangli containsString:@"周一"])
    {
        temp = @"星期一";
    }
    else if([yangli containsString:@"Tue"] || [yangli containsString:@"周二"])
    {
        temp = @"星期二";
    }
    else if([yangli containsString:@"Wed"] || [yangli containsString:@"周三"])
    {
        temp = @"星期三";
    }
    else if([yangli containsString:@"Thu"] || [yangli containsString:@"周四"])
    {
        temp = @"星期四";
    }
    else if([yangli containsString:@"Fri"] || [yangli containsString:@"周五"])
    {
        temp = @"星期五";
    }
    else if([yangli containsString:@"Sat"]|| [yangli containsString:@"周六"])
    {
        temp = @"星期六";
    }
    
    if(temp && temp.length > 0)
    {
        
        if(yangli && yangli.length >= 11)
        {
            yangliLabel.text = [NSString stringWithFormat:@"%@ %@",[yangli substringToIndex:11],temp];
        }
    }
}
- (void)setNongli:(NSString *)nongli
{
    nongliLabel.text = nongli;
}
- (void)setRiqi:(NSString *)riqi
{
    NSString* riliText = riqi.length == 1 ? [NSString stringWithFormat:@"0%@",riqi] : riqi;
    riqiLabel.text = riliText;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
