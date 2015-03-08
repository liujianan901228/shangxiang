//  CalendarTest
//
//  Created by mac on 13-8-27.
//  Copyright (c) 2013年 caobo. All rights reserved.
//

#import <Foundation/Foundation.h>

struct SolarTerm
{
	__unsafe_unretained NSString *solarName;
	int solarDate;
};

@interface LunarCalendar : NSObject
{	
//	NSArray *HeavenlyStems;//天干表
//	NSArray *EarthlyBranches;//地支表
//	NSArray *LunarZodiac;//生肖表
//	NSArray *SolarTerms;//24节气表
	NSArray *arrayMonth;//农历月表
	NSArray *arrayDay;//农历天表

	NSDate *thisdate;
	
	NSInteger year;//年
	NSInteger month;//月
	NSInteger day;//日
	
	NSInteger lunarYear;	//农历年
	NSInteger lunarMonth;	//农历月
	NSInteger doubleMonth;	//闰月
	bool isLeap;	  //是否闰月标记
	NSInteger lunarDay;	//农历日
	
	struct SolarTerm solarTerm[2];
	
	NSString *yearHeavenlyStem;//年天干
	NSString *monthHeavenlyStem;//月天干
	NSString *dayHeavenlyStem;//日天干
	
	NSString *yearEarthlyBranch;//年地支
	NSString *monthEarthlyBranch;//月地支
	NSString *dayEarthlyBranch;//日地支
	
	NSString *monthLunar;//农历月
	NSString *dayLunar;//农历日

}

-(void)loadWithDate:(NSDate *)date;//加载数据

-(void)InitializeValue;//添加数据
-(NSInteger)LunarYearDays:(NSInteger)y;
-(NSInteger)DoubleMonth:(NSInteger)y;
-(NSInteger)DoubleMonthDays:(NSInteger)y;
-(NSInteger)MonthDays:(NSInteger)y :(NSInteger)m;
//-(void)ComputeSolarTerm;

-(double)Term:(NSInteger)y :(NSInteger)n :(bool)pd;
-(double)AntiDayDifference:(NSInteger)y :(double)x;
-(double)EquivalentStandardDay:(NSInteger)y :(NSInteger)m :(NSInteger)d;
-(NSInteger)IfGregorian:(NSInteger)y :(NSInteger)m :(NSInteger)d :(NSInteger)opt;
-(NSInteger)DayDifference:(NSInteger)y :(NSInteger)m :(NSInteger)d;
-(double)Tail:(double)x;

-(NSInteger)getDay;
-(NSInteger)getMonth;
-(NSString *)MonthLunar;//农历
-(NSString *)DayLunar;//农历日
//-(NSString *)ZodiacLunar;//年生肖
-(NSString *)YearHeavenlyStem;//年天干
-(NSString *)MonthHeavenlyStem;//月天干
-(NSString *)DayHeavenlyStem;//日天干
-(NSString *)YearEarthlyBranch;//年地支
-(NSString *)MonthEarthlyBranch;//月地支
-(NSString *)DayEarthlyBranch;//日地支
//-(NSString *)SolarTermTitle;//节气
-(bool)IsLeap;//是不是农历闰年？？
-(int)GregorianYear;//阳历年
-(int)GregorianMonth;//阳历月
-(int)GregorianDay;//阳历天
-(int)Weekday;//一周的第几天
//-(NSString *)Constellation;//星座

@end


@interface NSDate (LunarCalendar)

/****************************************************
 *@Description:获得NSDate对应的中国日历（农历）的NSDate
 *@Params:nil
 *@Return:NSDate对应的中国日历（农历）的LunarCalendar
 ****************************************************/
- (LunarCalendar *)chineseCalendarDate;//加载中国农历


@end