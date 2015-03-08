//
//  JTCalendarMonthWeekDaysView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarMonthWeekDaysView.h"

@implementation JTCalendarMonthWeekDaysView

static NSArray *cacheDaysOfWeeks;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{    
    for(NSString *day in [self daysOfWeek]){
        UILabel *view = [UILabel new];
        
        view.font = self.calendarManager.calendarAppearance.weekDayTextFont;
        view.textColor = self.calendarManager.calendarAppearance.weekDayTextColor;
        
        view.textAlignment = NSTextAlignmentCenter;
        view.text = day;
        
        if(([day isEqualToString:@"六"]) || ([day isEqualToString:@"日"]))
        {
            view.textColor = [UIColor colorWithRed:211./256. green:147./256. blue:72./256. alpha:1];
        }
        
        [self addSubview:view];
    }
}

- (NSArray *)daysOfWeek
{
    if(cacheDaysOfWeeks){
        return cacheDaysOfWeeks;
    }
    NSArray *weekName = [[NSArray alloc ] initWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
    //arrayWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
//    NSDateFormatter *dateFormatter = [NSDateFormatter new];
//    NSMutableArray *days = [[dateFormatter weekdaySymbols] mutableCopy];
//        
//    // Redorder days for be conform to calendar
//    {
//        NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
//        NSUInteger firstWeekday = (calendar.firstWeekday + 6) % 1; // Sunday == 1, Saturday == 7
//                
//        for(int i = 0; i < firstWeekday; ++i){
//            id day = [days firstObject];
//            [days removeObjectAtIndex:0];
//            [days addObject:day];
//        }
//    }
//    
//    switch(self.calendarManager.calendarAppearance.weekDayFormat){
//        case JTCalendarWeekDayFormatSingle:
//            for(NSInteger i = 0; i < days.count; ++i){
//                NSString *day = days[i];
//                [days replaceObjectAtIndex:i withObject:[[day uppercaseString] substringToIndex:1]];
//            }
//            break;
//        case JTCalendarWeekDayFormatShort:
//            for(NSInteger i = 0; i < days.count; ++i){
//                NSString *day = days[i];
//                [days replaceObjectAtIndex:i withObject:[[day uppercaseString] substringToIndex:3]];
//            }
//            break;
//        case JTCalendarWeekDayFormatFull:
//            for(NSInteger i = 0; i < days.count; ++i){
//                NSString *day = days[i];
//                [days replaceObjectAtIndex:i withObject:[day uppercaseString]];
//            }
//            break;
//    }
//    
//    cacheDaysOfWeeks = days;
    cacheDaysOfWeeks = weekName;
    return cacheDaysOfWeeks;
}

- (void)layoutSubviews
{
    CGFloat x = 0;
    CGFloat width = self.frame.size.width / 7.;
    CGFloat height = self.frame.size.height;
    
    for(UIView *view in self.subviews){
        view.frame = CGRectMake(x, 0, width, height);
        x = CGRectGetMaxX(view.frame);
    }
    
    // No need to call [super layoutSubviews]
}

+ (void)beforeReloadAppearance
{
    cacheDaysOfWeeks = nil;
}

- (void)reloadAppearance
{
    for(int i = 0; i < self.subviews.count; ++i){
        UILabel *view = [self.subviews objectAtIndex:i];
        
        view.font = self.calendarManager.calendarAppearance.weekDayTextFont;
        view.textColor = self.calendarManager.calendarAppearance.weekDayTextColor;
        
        NSString *string = [[self daysOfWeek] objectAtIndex:i];
        
        if(([string isEqualToString:@"六"]) || ([string isEqualToString:@"日"]))
        {
            view.textColor = [UIColor colorWithRed:211./256. green:147./256. blue:72./256. alpha:1];
        }
        
        
        view.text = string;
    }
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
