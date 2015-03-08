//
//  JTCalendarAppearance.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarAppearance.h"

@implementation JTCalendarAppearance

- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
        
    [self setDefaultValues];
    
    return self;
}

- (void)setDefaultValues
{
    self.isWeekMode = NO;
    
    self.weekDayFormat = JTCalendarWeekDayFormatShort;
    
    self.ratioContentMenu = 2.;
    self.dayCircleRatio = 1.;
    self.dayDotRatio = 1. / 9.;
    
    self.menuMonthTextFont = [UIFont systemFontOfSize:17.];
    self.weekDayTextFont = [UIFont systemFontOfSize:11];
    self.dayTextFont = [UIFont systemFontOfSize:19];
    self.daySmallTextFont = [UIFont systemFontOfSize:10];
    
    self.menuMonthTextColor = [UIColor blackColor];
    self.weekDayTextColor = [UIColor colorWithRed:152./256. green:147./256. blue:157./256. alpha:1.];
    
    [self setDayDotColorForAll:UIColorFromRGB(0xf56d01)];
    [self setDayTextColorForAll:UIColorFromRGB(0x737574)];
    
    self.dayTextColorOtherMonth = [UIColor clearColor];
    self.dayDotColorOtherMonth = [UIColor clearColor];
    self.daySmallTextColorOtherMonth = [UIColor clearColor];
    self.daySmallTextColor = [UIColor colorWithRed:207./256. green:147./256. blue:75./256. alpha:1];
    
    self.dayCircleColorSelected = [UIColor colorWithRed:221./256. green:221./256. blue:221./256. alpha:1];
    self.dayTextColorSelected = UIColorFromRGB(0xff1c00);
    self.dayDotColorSelected = UIColorFromRGB(0xf56d01);
    
    self.dayCircleColorSelectedOtherMonth = self.dayCircleColorSelected;
    self.dayTextColorSelectedOtherMonth = self.dayTextColorSelected;
    self.dayDotColorSelectedOtherMonth = self.dayDotColorSelected;
    
    self.dayCircleColorToday = [UIColor colorWithRed:251./256. green:241./256. blue:205./256. alpha:1];
    self.dayTextColorToday = UIColorFromRGB(0xff1c00);
    self.dayDotColorToday = UIColorFromRGB(0xf56d01);
    
    self.dayCircleColorTodayOtherMonth = [UIColor clearColor];
    self.dayTextColorTodayOtherMonth = [UIColor clearColor];
    self.dayDotColorTodayOtherMonth = [UIColor clearColor];
}

- (NSCalendar *)calendar
{
    static NSCalendar *calendar;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        calendar.timeZone = [NSTimeZone localTimeZone];
    });
    
    return calendar;
}

- (void)setDayDotColorForAll:(UIColor *)dotColor
{
    self.dayDotColor = dotColor;
    self.dayDotColorSelected = dotColor;
    
    self.dayDotColorOtherMonth = dotColor;
    self.dayDotColorSelectedOtherMonth = dotColor;
    
    self.dayDotColorToday = dotColor;
    self.dayDotColorTodayOtherMonth = dotColor;
}

- (void)setDayTextColorForAll:(UIColor *)textColor
{
    self.dayTextColor = textColor;
    self.dayTextColorSelected = textColor;
    
    self.dayTextColorOtherMonth = textColor;
    self.dayTextColorSelectedOtherMonth = textColor;
    
    self.dayTextColorToday = textColor;
    self.dayTextColorTodayOtherMonth = textColor;
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
