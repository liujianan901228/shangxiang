#import "CalendarViewController.h"
#import "LunarCalendar.h"
#import "AddBirthdayViewController.h"
#import "CalendarDataSource.h"
#import "editRemindViewController.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"
#import "JTCalendarMonthWeekDaysView.h"

@interface CalendarViewController ()
{
    BOOL isFirstRead;
}
@end

@implementation CalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"佛历";
    isFirstRead = YES;
    self.view.backgroundColor = UIColorFromRGB(0xf6f8f7);
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.calendar = [JTCalendar new];
    
    // All modifications on calendarAppearance have to be done before setMenuMonthsView and setContentView
    // Or you will have to call reloadAppearance
    {
        self.calendar.calendarAppearance.calendar.firstWeekday = 1; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
        self.calendar.calendarAppearance.ratioContentMenu = 1.;
    }
    
    self.calendarMenuView = [[JTCalendarMenuView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 30)];
    self.calendarContentView = [[JTCalendarContentView alloc] initWithFrame:CGRectMake(0, self.calendarMenuView.bottom, self.view.frame.size.width, 260)];
    
    
    [self.view addSubview:self.calendarMenuView];
    [self.view addSubview:self.calendarContentView];
    
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
    
    UIButton *buttonToday = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonToday.frame = CGRectMake(self.view.frame.size.width-50 , 20, 50, 50);
    UIFont *font = [UIFont systemFontOfSize:21];
    buttonToday.titleLabel.font = font;
    [buttonToday setTitle:@"今" forState:UIControlStateNormal];
    [buttonToday setTitleColor:[UIColor colorWithRed:211./256. green:147./256. blue:72./256. alpha:1] forState:UIControlStateNormal];
    [buttonToday setBackgroundColor:[UIColor clearColor]];
    [buttonToday addTarget:self action:@selector(didGoTodayTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonToday];
    
    
    UIButton* leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 60, 30)];
    [leftButton setImage:[UIImage imageForKey:@"left_arrow"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageForKey:@"left_arrow"] forState:UIControlStateHighlighted];
    leftButton.tag = 10096;
    leftButton.center = CGPointMake(self.view.frame.size.width*.25, self.calendarMenuView.centerY);
    [leftButton addTarget:self action:@selector(buttonScroll:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UIButton* rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 60, 30)];
    [rightButton setImage:[UIImage imageForKey:@"right_arrow"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageForKey:@"right_arrow"] forState:UIControlStateHighlighted];
    rightButton.tag = 10097;
    rightButton.center = CGPointMake(self.view.frame.size.width*.75, self.calendarMenuView.centerY);
    [rightButton addTarget:self action:@selector(buttonScroll:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    


    self.detailView = [[CalendarDetailView alloc] initWithFrame:CGRectMake(0, self.calendarContentView.bottom + 8, self.view.frame.size.width*3/5., 50)];
    self.detailView.backgroundColor = UIColorFromRGB(0xf6f8f7);
//    self.detailView.layer.borderColor = [UIColor colorWithRed:225./255. green:228./255. blue:226./255. alpha:1].CGColor;
//    self.detailView.layer.borderWidth = 0.8f;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 EEE"];
    self.detailView.yangli = [formatter stringFromDate:self.calendar.currentDate];
    
    LunarCalendar *lunarCalendar = [self.calendar.currentDate chineseCalendarDate];
    self.detailView.nongli = [NSString stringWithFormat:@"农历%@%@",[lunarCalendar MonthLunar],[lunarCalendar DayLunar]];
    self.detailView.riqi = [NSString stringWithFormat:@"%ld",(long)self.calendar.currentDate.day];
    [self.view addSubview:self.detailView];
    
    UIView *addBirthdayView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*3/5., self.calendarContentView.bottom + 8, self.view.frame.size.width*2/5., 50)];
    addBirthdayView.tag = 10084;
    
    
    NSString *addStr = @"添加亲友生日";
    UIFont *addFont = [UIFont systemFontOfSize:15.];
    float addStrWidth = [addStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:addFont,NSFontAttributeName, nil]].width;
    UIImage *addBirImage = [UIImage imageForKey:@"plus"];
    float addOrign_x = (addBirthdayView.frame.size.width-(addStrWidth+addBirImage.size.width))*.5f;
    UIImageView *addBirImageView = [[UIImageView alloc] initWithFrame:CGRectMake(addOrign_x, 0, addBirImage.size.width, addBirImage.size.height)];
    addBirImageView.center = CGPointMake(addBirImageView.center.x, addBirthdayView.height/2.);
    addBirImageView.image = addBirImage;
    UILabel *addBirLabel = [[UILabel alloc] initWithFrame:CGRectMake(addBirImageView.frame.size.width+addOrign_x + 3, 0, addStrWidth, 50)];
    addBirLabel.text = addStr;
    addBirLabel.font = addFont;
    addBirLabel.textColor = [UIColor colorWithRed:223./255. green:88./255. blue:20./255. alpha:1];
    addBirLabel.textAlignment = NSTextAlignmentLeft;
//    addBirthdayView.layer.borderColor = [UIColor colorWithRed:225./255. green:228./255. blue:226./255. alpha:1].CGColor;
//    addBirthdayView.layer.borderWidth = 0.8f;
    
    [addBirthdayView addSubview:addBirImageView];
    [addBirthdayView addSubview:addBirLabel];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    lineLabel.backgroundColor = [UIColor colorWithRed:225./255. green:228./255. blue:226./255. alpha:1];
    [self.detailView addSubview:lineLabel];
    
    lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.detailView.frame.size.width, 5, 1, self.detailView.frame.size.height-10)];
    lineLabel.backgroundColor = [UIColor colorWithRed:225./255. green:228./255. blue:226./255. alpha:1];
    [self.detailView addSubview:lineLabel];
    
    

    UITapGestureRecognizer *tapAddBir = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAddBirthday)];
    [addBirthdayView addGestureRecognizer:tapAddBir];
    
    [self.view addSubview:addBirthdayView];
    
    UIView *holidayView = [[UIView alloc] initWithFrame:CGRectMake(0, self.detailView.frame.size.height+self.detailView.frame.origin.y, self.view.frame.size.width, 40)];
    holidayView.backgroundColor = UIColorFromRGB(0xf6f8f7);
    holidayView.tag = 10085;
    holidayView.layer.borderWidth = 0.8;
    holidayView.layer.borderColor = [UIColor colorWithRed:225./255. green:228./255. blue:226./255. alpha:1].CGColor;
    UIImage *buddImage = [UIImage imageForKey:@"budd"];
    UIImageView *buddImageView = [[UIImageView alloc] initWithImage:buddImage];
    [buddImageView setContentMode:UIViewContentModeScaleAspectFit];
    buddImageView.frame = CGRectMake(8, 5, 30, 30);
    buddImageView.tag = 10011;
    [holidayView addSubview:buddImageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(buddImageView.right + 8, 0, self.view.frame.size.width*5./6., 40)];
    label.userInteractionEnabled = YES;
    label.tag = 1000;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:90./255. green:90./255. blue:90./255. alpha:1];
    [holidayView addSubview:label];
    [self.view addSubview:holidayView];
    
    UIImageView *folibg = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.detailView.bottom, self.view.frame.size.width, self.view.height - self.detailView.bottom)];
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    [folibg sd_setImageWithURL:[NSURL URLWithString:[def objectForKey:@"foliBg"]] placeholderImage:[UIImage imageForKey:@"folibg"]];
    [folibg setImage:[UIImage imageForKey:@"foli_bg"]];
    folibg.tag = 10086;
    folibg.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:folibg];
    


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectHoliday:) name:@"selectHoliday" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unSelectHoliday) name:@"unSelectHoliday" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCalendar) name:@"reloadCalendar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCalendar) name:AppUserLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCalendar) name:AppUserLogoutNotification object:nil];
    
    UISwipeGestureRecognizer *gesDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(transitionExample:)];
    [gesDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:gesDown];
    
    UISwipeGestureRecognizer *gesUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(transitionExample:)];
    [gesUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:gesUp];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRemindView)];
    [label addGestureRecognizer:tap];
    [self reloadCalendar];
    
    JTCalendarMonthWeekDaysView* weekdaysView = [[JTCalendarMonthWeekDaysView alloc] initWithFrame:CGRectMake(0, 60, self.view.width, 30)];
    weekdaysView.backgroundColor = self.view.backgroundColor;
    [JTCalendarMonthWeekDaysView beforeReloadAppearance];
    [weekdaysView reloadAppearance];
    [self.view addSubview:weekdaysView];
    [self setNongliBg:[[NSDate date] chineseCalendarDate] folibg:folibg];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
   
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.calendar reloadData]; // Must be call in viewDidAppear
}

#pragma mark - Buttons callback

- (void)buttonScroll:(UIButton *)button
{
    if (button.tag == 10096) { //L
        [self.calendar goLastMonth];
    }
    else//R
    {
        [self.calendar goNextMonth];
    }
}

- (void)didGoTodayTouch
{
    [self.calendar setCurrentDateSelected:[NSDate date]];
    [self.calendar setCurrentDate:[NSDate date]];
    [self calendarDidDateSelected:nil date:[NSDate date]];
}

- (void)didChangeModeTouch
{
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    
//    [self transitionExample];
}

- (void)pushAddBirthday
{
    if([[Reachability reachabilityWithHostName:@"www.shangxiang.com"] currentReachabilityStatus] == kNotReachable)
    {
        [self showTimedHUD:YES message:@"当前无网络连接，请检查您的网络"];
        return;
    }
    else if(!USEROPERATIONHELP.isLogin)
    {
        [APPNAVGATOR turnToLoginGuide];
        return;
    }
//    NSLog(@"add birthday");
    AddBirthdayViewController *ABVC = [[AddBirthdayViewController alloc] init];
    ABVC->selectDefaultDay = (int)self.calendar.currentDateSelected.day;
    ABVC->selectDefaultMonth = (int)self.calendar.currentDateSelected.month;
    ABVC->selectDefaultYear = (int)self.calendar.currentDateSelected.year;
    [self.navigationController pushViewController:ABVC animated:YES];
}

- (void)tapRemindView
{
    UIView *holidayView = [self.view viewWithTag:10085];
    
    UILabel *label = (UILabel *)[holidayView viewWithTag:1000];
    NSString *remindStr = label.text;
    NSString *newStr = [remindStr substringToIndex:remindStr.length-2];
    
    if (![newStr hasSuffix:@"-"]) {
        return;
    }

    editRemindViewController *ERVC = [[editRemindViewController alloc] init];
    ERVC.selectDate = self.calendar.currentDateSelected;
    [self.navigationController pushViewController:ERVC animated:YES];
    
}

#pragma mark - JTCalendarDataSource

- (NSString *)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date WithDay:(NSInteger)day WithMonth:(NSInteger)month
{
    return [LUtility getBuildListName:month day:day];
}

- (NSString *)calendarHaveRemind:(JTCalendar *)calendar date:(NSDate *)date
{
    static NSArray *remindArray;
    
    if (isFirstRead) {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSString *str = [def objectForKey:@"remindArray"];
        if ([str isKindOfClass:[NSArray class]]) {
            remindArray = [def objectForKey:@"remindArray"];
        }
        else
        {
           return nil;
        }
        isFirstRead = NO;
    }
    
    
    if (remindArray.count == 0) {
        return nil;
    }
    
    for (NSDictionary *dic in remindArray) {
        NSDate *remindDate = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"reminddate"] integerValue]];
        
        if ([remindDate isEqualToDate:date]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            return [NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"relativesname"],[formatter stringFromDate:remindDate]];

        }
    }
    return nil;
}


- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 EEE"];
    self.detailView.yangli = [formatter stringFromDate:self.calendar.currentDateSelected];
    
    LunarCalendar *lunarCalendar = [self.calendar.currentDateSelected chineseCalendarDate];
    self.detailView.nongli = [NSString stringWithFormat:@"农历%@%@",[lunarCalendar MonthLunar],[lunarCalendar DayLunar]];
    
    self.detailView.riqi = [NSString stringWithFormat:@"%ld",(long)self.calendar.currentDateSelected.day];
    [self setNongliBg:lunarCalendar folibg:(UIImageView*)[self.view viewWithTag:10086]];
}

- (void)setNongliBg:(LunarCalendar*)lunarCalendar folibg:(UIImageView*)folibg
{
    if(!folibg) return;
    if(([lunarCalendar getMonth] == 2 && [lunarCalendar getDay] == 8)
       || ([lunarCalendar getMonth] == 2 && [lunarCalendar getDay] == 21)
       || ([lunarCalendar getMonth] == 2 && [lunarCalendar getDay] == 15)
       || ([lunarCalendar getMonth] == 7 && [lunarCalendar getDay] == 30)
       || ([lunarCalendar getMonth] == 3 && [lunarCalendar getDay] == 16)
       || ([lunarCalendar getMonth] == 4 && [lunarCalendar getDay] == 8)
       || ([lunarCalendar getMonth] == 4 && [lunarCalendar getDay] == 4)
       || ([lunarCalendar getMonth] == 4 && [lunarCalendar getDay] == 15)
       || ([lunarCalendar getMonth] == 1 && [lunarCalendar getDay] == 6)
       || ([lunarCalendar getMonth] == 1 && [lunarCalendar getDay] == 1)
       )
    {
        [folibg setImage:[UIImage imageForKey:[NSString stringWithFormat:@"foli_%zd_%zd",[lunarCalendar getMonth],[lunarCalendar getDay]]]];
    }
    else
    {
        [folibg setImage:[UIImage imageForKey:@"foli_bg"]];
    }
}

#pragma mark - Transition examples

- (void)transitionExample:(UISwipeGestureRecognizer *)ges
{
    if ((ges.direction == UISwipeGestureRecognizerDirectionUp) && (self.calendar.calendarAppearance.isWeekMode)) {
        return;
    }
    if ((ges.direction == UISwipeGestureRecognizerDirectionDown) && (!self.calendar.calendarAppearance.isWeekMode)) {
        return;
    }
    
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    
    
    
    CGFloat newHeight = 260;
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = 75.;
    }
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.calendarContentViewHeight.constant = newHeight;
                         if (self.calendar.calendarAppearance.isWeekMode)
                         {
                             self.calendarContentView.frame = CGRectMake(0, self.calendarMenuView.bottom, self.view.frame.size.width, 75);
                         }
                         else
                         {
                             self.calendarContentView.frame = CGRectMake(0, self.calendarMenuView.bottom, self.view.frame.size.width, 260);
                         }
                         [self setDetailAndBgFrame:self.calendar.calendarAppearance.isWeekMode];
                         [self.view layoutIfNeeded];
                     }];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.calendarContentView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.calendar reloadAppearance];
                         if(self.calendar.currentDateSelected)
                         {
                             [self.calendar setCurrentDate:self.calendar.currentDateSelected];
                         }
                         else
                         {
                             NSDateComponents *dayComponent = [NSDateComponents new];
                             dayComponent.month = self.calendar.currentDate.month;
                             dayComponent.year = self.calendar.currentDate.year;
                             dayComponent.day = 1;
                             NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
                             NSDate *myDate1 = [myCal dateFromComponents:dayComponent];
                             [self.calendar setCurrentDate:myDate1];
                         }
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.calendarContentView.layer.opacity = 1;
                                              
                                              
                                          }];
                     }];
    [self unSelectHoliday];
}

//- (void)setDetailAndBgFrame:(BOOL)isWeekMode
//{
//    float orgin_y = self.calendarContentView.bottom;
//    
//    self.detailView.frame = CGRectMake(0, orgin_y,  self.view.frame.size.width*3/5., 50);
//    UIView *addBirView = [self.view viewWithTag:10084];
//    addBirView.frame = CGRectMake(self.view.frame.size.width*3/5., orgin_y, self.view.frame.size.width*2/5., 50);
//    
//    UIView *holidayView = [self.view viewWithTag:10085];
//    UIImageView *folibg = (UIImageView *)[self.view viewWithTag:10086];
//    
//    holidayView.frame = CGRectMake(0, self.detailView.frame.size.height+self.detailView.frame.origin.y, self.view.frame.size.width, 40);
//    folibg.frame = CGRectMake(0, holidayView.bottom, self.view.frame.size.width, self.view.height-holidayView.bottom +40);
//}

- (void)setDetailAndBgFrame:(BOOL)isWeekMode
{
    float orgin_y = 328;
    if (isWeekMode)
    {
        orgin_y = 143;
    }
    
    self.detailView.frame = CGRectMake(0, orgin_y,  self.view.frame.size.width*3/5., 50);
    UIView *addBirView = [self.view viewWithTag:10084];
    addBirView.frame = CGRectMake(self.view.frame.size.width*3/5., orgin_y, self.view.frame.size.width*2/5., 50);
    
    UIView *holidayView = [self.view viewWithTag:10085];
    UIImageView *folibg = (UIImageView *)[self.view viewWithTag:10086];
    
    holidayView.frame = CGRectMake(0, self.detailView.frame.size.height+self.detailView.frame.origin.y, self.view.frame.size.width, 40);
    if (orgin_y == 143) {
        folibg.frame = CGRectMake(0, folibg.frame.origin.y-(328-143), self.view.frame.size.width, self.view.frame.size.height-175);
    }
    else
    {
        folibg.frame = CGRectMake(0, folibg.frame.origin.y+(328-143), self.view.frame.size.width, self.view.frame.size.height-175);
    }
    
}

#pragma mark - selectDelegate
int once = 0;
- (void)selectHoliday:(NSNotification *)noti
{
    NSString *holidayName = [noti object];
    
    UIView *holidayView = [self.view viewWithTag:10085];
    UIImageView *folibg = (UIImageView *)[self.view viewWithTag:10086];
    
    UILabel *label = (UILabel *)[holidayView viewWithTag:1000];
    label.text = holidayName;
    
    
    
    UIImageView *buddImageView = (UIImageView *)[holidayView viewWithTag:10011];
    UIImage *buddImage;
    NSString *newStr = [holidayName substringToIndex:holidayName.length-2];
    if ([newStr hasSuffix:@"-"]) {
        buddImage = [UIImage imageForKey:@"time"];
    }
    else
    {
        buddImage = [UIImage imageForKey:@"budd"];
    }
    buddImageView.image = buddImage;
    
    
    [UIView animateWithDuration:0.5f animations:^{
        folibg.frame = CGRectMake(0, holidayView.bottom, self.view.frame.size.width, folibg.frame.size.height);
    }];
    
    if (self.calendar.calendarAppearance.isWeekMode) {
        once = 1;
    }
}

- (void)unSelectHoliday
{
    
    if (once == 1) {
        once = 0;
        return;
    }
    
    
    UIImageView *folibg = (UIImageView *)[self.view viewWithTag:10086];
    
    
    [UIView animateWithDuration:0.5f animations:^
    {
       folibg.frame = CGRectMake(0, self.detailView.bottom
                                 , self.view.frame.size.width, folibg.frame.size.height);
    }];

}

- (void)reloadCalendar
{
    [CalendarDataSource getCalendarRemindList:0 success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def removeObjectForKey:@"remindArray"];
            
            if (![obj isKindOfClass:[NSString class]]) {
                [def setObject:(NSArray *)obj forKey:@"remindArray"];
            }
            isFirstRead = YES;
            [self.calendar reloadData];
            [self.calendar reloadAppearance];
        });


    } failed:^(id error) {
       
    }];

}
@end