#import "BaseViewController.h"
#import "JTCalendar.h"
#import "CalendarDetailView.h"
#import "calendarDataSource.h"

@interface CalendarViewController : BaseViewController<JTCalendarDataSource>
{

}
@property (strong, nonatomic) JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic) JTCalendarContentView *calendarContentView;

@property (strong, nonatomic) NSLayoutConstraint *calendarContentViewHeight;

@property (strong, nonatomic) JTCalendar *calendar;

@property (strong, nonatomic) CalendarDetailView *detailView;

@end
