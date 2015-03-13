//
//  JTCalendarMenuView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarMenuView.h"

#import "JTCalendar.h"
#import "JTCalendarMenuMonthView.h"

#define NUMBER_PAGES_LOADED 5 // Must be the same in JTCalendarView, JTCalendarMenuView, JTCalendarContentView

@interface JTCalendarMenuView(){
    NSMutableArray *monthsViews;
}

@end

@implementation JTCalendarMenuView

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
    monthsViews = [NSMutableArray new];
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.decelerationRate = 0.2;
    self.bounces = NO;
    self.backgroundColor = UIColorFromRGB(0xf6f8f7);
    
//    NSLog(@"decelerationRate = %f %f",UIScrollViewDecelerationRateFast,UIScrollViewDecelerationRateNormal);
//    
    for(int i = 0; i < NUMBER_PAGES_LOADED; ++i){
        JTCalendarMenuMonthView *monthView = [JTCalendarMenuMonthView new];
                
        [self addSubview:monthView];
        [monthsViews addObject:monthView];
    }
    
}




- (void)layoutSubviews
{
    [self configureConstraintsForSubviews];
        
    [super layoutSubviews];
}

- (void)configureConstraintsForSubviews
{
//    self.contentOffset = CGPointMake(self.contentOffset.x, 0); // Prevent bug when contentOffset.y is negative
    
    CGFloat x = 0;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    if(self.calendarManager.calendarAppearance.ratioContentMenu != 1.){
        width = self.frame.size.width / self.calendarManager.calendarAppearance.ratioContentMenu;
        x = (self.frame.size.width - width) / 2.;
    }
    
    for(UIView *view in monthsViews){
        view.frame = CGRectMake(x, 0, width, height);
        x = CGRectGetMaxX(view.frame);
    }
    
    self.contentSize = CGSizeMake(width * NUMBER_PAGES_LOADED, height);
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    self->_currentDate = currentDate;
 
    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    NSDateComponents *comps = [calendar components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:currentDate];
    NSInteger currentMonthIndex = comps.month;
    NSInteger currentYearIndex = comps.year;
    
    for(int i = 0; i < NUMBER_PAGES_LOADED; ++i){
        JTCalendarMenuMonthView *monthView = monthsViews[i];
        NSInteger monthIndex = currentMonthIndex - (NUMBER_PAGES_LOADED / 2) + i;
        
        if (monthIndex <= 0) {
            currentYearIndex--;
        }
        else if (monthIndex > 12)
        {
            currentYearIndex++;
        }
        
        monthIndex = monthIndex % 12;


        [monthView setMonthIndex:monthIndex andYearIndex:currentYearIndex];
        currentYearIndex = comps.year;
    }
}

#pragma mark - Load Month

- (void)loadPreviousMonth
{
    JTCalendarMenuMonthView *monthView = [monthsViews lastObject];
    
    [monthsViews removeLastObject];
    [monthsViews insertObject:monthView atIndex:0];
    
    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    
    // Update currentDate
    {
        NSDateComponents *dayComponent = [NSDateComponents new];
        dayComponent.month = -1;
        self->_currentDate = [calendar dateByAddingComponents:dayComponent toDate:self.currentDate options:0];
    }
    
    // Update monthView
    {
        NSDateComponents *comps = [calendar components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self.currentDate];
        NSInteger currentMonthIndex = comps.month;
        NSInteger currentYearIndex = comps.year;
        
        NSInteger monthIndex = currentMonthIndex - (NUMBER_PAGES_LOADED / 2);
        
        if (monthIndex <= 0) {
            currentYearIndex--;
        }
        else if (monthIndex > 12)
        {
            currentYearIndex++;
        }
        
        
        
        monthIndex = monthIndex % 12;
        [monthView setMonthIndex:monthIndex andYearIndex:currentYearIndex];
    }
    
    [self configureConstraintsForSubviews];
}

- (void)loadNextMonth
{
    JTCalendarMenuMonthView *monthView = [monthsViews firstObject];
    
    [monthsViews removeObjectAtIndex:0];
    [monthsViews addObject:monthView];
    
    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    
    // Update currentDate
    {
        NSDateComponents *dayComponent = [NSDateComponents new];
        dayComponent.month = 1;
        self->_currentDate = [calendar dateByAddingComponents:dayComponent toDate:self.currentDate options:0];
    }
    
    // Update monthView
    {
        NSDateComponents *comps = [calendar components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self.currentDate];
        NSInteger currentMonthIndex = comps.month;
        NSInteger currentYearIndex = comps.year;
        
        NSInteger monthIndex = currentMonthIndex - (NUMBER_PAGES_LOADED / 2) + (NUMBER_PAGES_LOADED - 1);
        
        if (monthIndex <= 0) {
            currentYearIndex--;
        }
        else if (monthIndex > 12)
        {
            currentYearIndex++;
        }
        
        monthIndex = monthIndex % 12;
        [monthView setMonthIndex:monthIndex andYearIndex:currentYearIndex];
    }
    
    [self configureConstraintsForSubviews];
}

#pragma mark - JTCalendarManager

- (void)setCalendarManager:(JTCalendar *)calendarManager
{
    self->_calendarManager = calendarManager;
    
    for(JTCalendarMenuMonthView *view in monthsViews){
        [view setCalendarManager:calendarManager];
    }
}

- (void)reloadAppearance
{
    self.scrollEnabled = !self.calendarManager.calendarAppearance.isWeekMode;
    
    [self configureConstraintsForSubviews];
    for(JTCalendarMenuMonthView *view in monthsViews){
        [view reloadAppearance];
    }
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
