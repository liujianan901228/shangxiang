//
//  JTCalendarMenuMonthView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarMenuMonthView.h"

@interface JTCalendarMenuMonthView(){
    UILabel *textLabel;
}

@end

@implementation JTCalendarMenuMonthView

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
    {
        textLabel = [UILabel new];
        [self addSubview:textLabel];
        
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor colorWithRed:211./256. green:147./256. blue:72./256. alpha:1];
    }
}

- (void)setMonthIndex:(NSInteger)monthIndex andYearIndex:(NSInteger)yearIndex
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
    }

    while(monthIndex <= 0){
        monthIndex += 12;
    }
    
//    textLabel.text = [[dateFormatter standaloneMonthSymbols][monthIndex - 1] capitalizedString];
    
    textLabel.text = [NSString stringWithFormat:@"%zd年%.2zd月",yearIndex,monthIndex];
    textLabel.textColor = [UIColor colorWithRed:211./256. green:147./256. blue:72./256. alpha:1];
    
}

- (void)layoutSubviews
{
    textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    // No need to call [super layoutSubviews]
}

- (void)reloadAppearance
{
//    textLabel.textColor = self.calendarManager.calendarAppearance.menuMonthTextColor;
    textLabel.textColor = [UIColor colorWithRed:211./256. green:147./256. blue:72./256. alpha:1];
    

    textLabel.font = self.calendarManager.calendarAppearance.menuMonthTextFont;
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
