//
//  JTCalendarDayView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarDayView.h"

#import "JTCircleView.h"

NSInteger lastDay;
NSInteger lastMonth;
NSInteger result;

@interface JTCalendarDayView (){
    JTCircleView *circleView;
    UILabel *textLabel;
    UILabel *textLabelSmall;
    JTCircleView *dotView;
    
    BOOL isSelected;
    
    NSInteger cacheIsToday;
    NSString *cacheCurrentDateText;

}
@end

static NSString *kJTCalendarDaySelected = @"kJTCalendarDaySelected";

@implementation JTCalendarDayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    self.layer.masksToBounds = YES;
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    

    lastDay = 0;
    result = 0;
    lastMonth = 0;
    
    [self commonInit];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

- (void)commonInit
{
    isSelected = NO;
    self.isOtherMonth = NO;
    
    {
        circleView = [JTCircleView new];
        [self addSubview:circleView];
    }
    
    {
        textLabel = [UILabel new];
        [self addSubview:textLabel];
    }
    
    {
        textLabelSmall = [UILabel new];
        [self addSubview:textLabelSmall];
    }
    
    {
        dotView = [JTCircleView new];
        [self addSubview:dotView];
        dotView.hidden = YES;
    }
    
    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)];

        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:gesture];
    }
    
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDaySelected:) name:kJTCalendarDaySelected object:nil];
    }
}

- (void)layoutSubviews
{
    [self configureConstraintsForSubviews];
    
    // No need to call [super layoutSubviews]
}

// Avoid to calcul constraints (very expensive)
- (void)configureConstraintsForSubviews
{
    textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    textLabelSmall.frame = CGRectMake(0, 0, self.frame.size.width*1.5, self.frame.size.height);
    textLabelSmall.lineBreakMode = NSLineBreakByCharWrapping;
    NSString *one = @"佛";
    float oneWidth = [one sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:textLabelSmall.font,NSFontAttributeName, nil]].width;
    textLabelSmall.bounds = CGRectMake(0, 0, oneWidth*4, textLabelSmall.frame.size.height);
    textLabel.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.3);
    textLabelSmall.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.68);

    CGFloat sizeCircle = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat sizeDot = sizeCircle;
    
//    sizeCircle = sizeCircle * self.calendarManager.calendarAppearance.dayCircleRatio;
    sizeDot = sizeDot * self.calendarManager.calendarAppearance.dayDotRatio;
    
    sizeCircle = roundf(sizeCircle);
    sizeDot = roundf(sizeDot);
    
    circleView.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    circleView.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    circleView.layer.cornerRadius = sizeCircle / 2.;
    
    dotView.frame = CGRectMake(0, 0, sizeDot, sizeDot);
    dotView.center = CGPointMake(self.frame.size.width / 2., (self.frame.size.height / 2.) + sizeDot * 3.5);
    dotView.layer.cornerRadius = sizeDot / 2.;
    
    
}

- (void)setDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
        [dateFormatter setDateFormat:@"d"];
    }
    static NSDateFormatter *dateFormatter1;
    if(!dateFormatter1){
        dateFormatter1 = [NSDateFormatter new];
        dateFormatter1.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    }
    static NSArray *arrayDay;
    if (!arrayDay) {
        arrayDay = [NSArray arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", @"三一", nil];
    }

    
    
    self->_date = date;
    textLabel.text = [dateFormatter stringFromDate:date];
    NSString * lunarday;
    
    
    
    NSString *dateStr = @"1930-01-01";
    NSDate *sinceDate = [dateFormatter1 dateFromString:dateStr];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:sinceDate toDate:date options:0];
    
    NSInteger sumdays = [components day];
    NSInteger go = sumdays - result;
    
    if ((lastDay == 0) || (go != 1) || (lastDay > 28)) {
        LunarCalendar *lunarCalendar = [date chineseCalendarDate];
        lunarday = [[NSString alloc]initWithString:lunarCalendar.DayLunar];
        lastDay = [lunarCalendar getDay];
        lastMonth = [lunarCalendar getMonth];
        result = sumdays;
    }
    else
    {
        lastDay++;
        result = sumdays;
        lunarday = [[NSString alloc]initWithString:arrayDay[lastDay-1]];
    }
    
    textLabelSmall.text = lunarday;
    
    self.luanMonth = lastMonth;
    self.luanDay = lastDay;
    cacheIsToday = -1;
    cacheCurrentDateText = nil;
}

- (void)didTouch
{
    if (self.isOtherMonth) {
        return;
    }
    
    
    
    [self setSelected:YES animated:YES];
    [self.calendarManager setCurrentDateSelected:self.date];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kJTCalendarDaySelected object:self.date];
    
    [self.calendarManager.dataSource calendarDidDateSelected:self.calendarManager date:self.date];
    
    if(!self.isOtherMonth){
        return;
    }
    
    NSInteger currentMonthIndex = [self monthIndexForDate:self.date];
    NSInteger calendarMonthIndex = [self monthIndexForDate:self.calendarManager.currentDate];
        
    currentMonthIndex = currentMonthIndex % 12;
    
    if(currentMonthIndex == (calendarMonthIndex + 1) % 12){
        [self.calendarManager loadNextMonth];
    }
    else if(currentMonthIndex == (calendarMonthIndex + 12 - 1) % 12){
        [self.calendarManager loadPreviousMonth];
    }
}

- (void)didDaySelected:(NSNotification *)notification
{
    NSDate *dateSelected = [notification object];
    
    if([self isSameDate:dateSelected]){
        if(!isSelected){
            [self setSelected:YES animated:YES];
        }
    }
    else if(isSelected){
        

        [self setSelected:NO animated:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    NSLog(@"date %@",self.date);
    if(isSelected == selected){
        animated = NO;
    }
    
    isSelected = selected;
    
    circleView.transform = CGAffineTransformIdentity;
    CGAffineTransform tr = CGAffineTransformIdentity;
    CGFloat opacity = 1.;
    NSString *str = [self.calendarManager.dataSource calendarHaveEvent:self.calendarManager date:self.date WithDay:self.luanDay WithMonth:self.luanMonth];
    
    if(selected){
        if(!self.isOtherMonth){
            circleView.color = [self.calendarManager.calendarAppearance dayCircleColorSelected];
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorSelected];
            dotView.color = [self.calendarManager.calendarAppearance dayDotColorSelected];
            
            if (str)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"selectHoliday" object:textLabelSmall.text];
            }
            else if (dotView.hidden == NO) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"selectHoliday" object:dotView.remindStr];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"unSelectHoliday" object:nil];
            }
        }
        else{
            circleView.color = [self.calendarManager.calendarAppearance dayTextColorOtherMonth];
            textLabelSmall.textColor = str ? [UIColor redColor] : [self.calendarManager.calendarAppearance daySmallTextColorOtherMonth];
            dotView.color = [self.calendarManager.calendarAppearance dayDotColorOtherMonth];
        }
        
        circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        tr = CGAffineTransformIdentity;
    }
    else if([self isToday])
    {
        if(!self.isOtherMonth){
            circleView.color = [self.calendarManager.calendarAppearance dayCircleColorToday];
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorToday];
            dotView.color = [self.calendarManager.calendarAppearance dayDotColorToday];
            textLabelSmall.textColor = str ? [UIColor redColor] : [self.calendarManager.calendarAppearance daySmallTextColor];
        }
        else{
            circleView.color = [self.calendarManager.calendarAppearance dayCircleColorTodayOtherMonth];
            textLabel.textColor = str ? [UIColor redColor] : [self.calendarManager.calendarAppearance dayTextColorTodayOtherMonth];
            dotView.color = [self.calendarManager.calendarAppearance dayDotColorTodayOtherMonth];
            textLabelSmall.textColor = str ? [UIColor redColor] : [self.calendarManager.calendarAppearance dayDotColorTodayOtherMonth];
        }
    }
    else{
        if(!self.isOtherMonth){
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColor];
            dotView.color = [self.calendarManager.calendarAppearance dayDotColor];
            
            if (textLabelSmall.textColor != [UIColor redColor]) {
                textLabelSmall.textColor = [self.calendarManager.calendarAppearance daySmallTextColor];

            }

        }
        else{
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorOtherMonth];
            textLabelSmall.textColor = [self.calendarManager.calendarAppearance daySmallTextColorOtherMonth];
            dotView.color = [self.calendarManager.calendarAppearance dayDotColorOtherMonth];
        }
        
        opacity = 0.;
    }
    
    if(animated){
        [UIView animateWithDuration:.3 animations:^{
            circleView.layer.opacity = opacity;
            circleView.transform = tr;
        }];
    }
    else{
        circleView.layer.opacity = opacity;
        circleView.transform = tr;
    }
}

- (void)setIsOtherMonth:(BOOL)isOtherMonth
{
    self->_isOtherMonth = isOtherMonth;
    [self setSelected:isSelected animated:NO];
}

- (void)reloadData
{
    NSString *remindStr = [self.calendarManager.dataSource calendarHaveRemind:self.calendarManager date:self.date];
    
    if (remindStr == nil)
    {
        dotView.hidden = YES;
    }
    else
    {
        dotView.hidden = NO;
        dotView.remindStr = [[NSString alloc] initWithString:remindStr];
        
        NSDate *now = [NSDate date];
        if ((self.date.year == now.year) && (self.date.month == now.month) && (self.date.day == now.day)) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectHoliday" object:dotView.remindStr];
        }
        
        
    }
    
    
    textLabelSmall.textColor = [self.calendarManager.calendarAppearance daySmallTextColor];
    NSString *str = [self.calendarManager.dataSource calendarHaveEvent:self.calendarManager date:self.date WithDay:self.luanDay WithMonth:self.luanMonth];
    
    if (str)
    {
        textLabelSmall.text = str;
        textLabelSmall.textColor = [UIColor redColor];
        
        NSDate *now = [NSDate date];
        if ((self.date.year == now.year) && (self.date.month == now.month) && (self.date.day == now.day)) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectHoliday" object:str];
        }
    }
    
    BOOL selected = [self isSameDate:[self.calendarManager currentDateSelected]];
    [self setSelected:selected animated:NO];
}

- (BOOL)isToday
{
    if(cacheIsToday == 0){
        return NO;
    }
    else if(cacheIsToday == 1){
        return YES;
    }
    else{
        if([self isSameDate:[NSDate date]]){
            cacheIsToday = 1;
            return YES;
        }
        else{
            cacheIsToday = 0;
            return NO;
        }
    }
}

- (BOOL)isSameDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    }
    
    if(!cacheCurrentDateText){
        cacheCurrentDateText = [dateFormatter stringFromDate:self.date];
    }
    
    NSString *dateText2 = [dateFormatter stringFromDate:date];
    
    if ([cacheCurrentDateText isEqualToString:dateText2]) {
        return YES;
    }
    
    return NO;
}

- (NSInteger)monthIndexForDate:(NSDate *)date
{
    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    NSDateComponents *comps = [calendar components:NSCalendarUnitMonth fromDate:date];
    return comps.month;
}

- (void)reloadAppearance
{
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = self.calendarManager.calendarAppearance.dayTextFont;
    
    textLabelSmall.textAlignment = NSTextAlignmentCenter;
    textLabelSmall.font = self.calendarManager.calendarAppearance.daySmallTextFont;
    
    [self configureConstraintsForSubviews];
    [self setSelected:isSelected animated:NO];
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
