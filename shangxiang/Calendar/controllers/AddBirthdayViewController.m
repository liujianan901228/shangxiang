//
//  AddBirthdayViewController.m
//  shangxiang
//
//  Created by 刘佳男 on 15/1/21.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "AddBirthdayViewController.h"
#import "Pickerview.h"
#import "BaseRequest.h"

#define FRAME (self.view.frame.size)

@interface AddBirthdayViewController ()<PickerViewDelegate,UITextFieldDelegate>
{
    Pickerview *pickerView;
    int selectType;
    NSArray *alertData;
    
    NSMutableArray *yearData;
    NSArray *nonglimonthData;
    NSArray *nongliDayData;
    NSArray *yangliDayData;
    NSArray *yanglimonthData;
    NSArray *EarthlyBranches;
    NSMutableArray *miniteData;
    
    NSInteger selectYear;
    NSInteger selectMonth;
    NSInteger selectDay;
    NSInteger selectRemind;
}
@end

@implementation AddBirthdayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"生日";
    self.view.backgroundColor = [UIColor colorWithRed:240./256. green:240./256. blue:240./256. alpha:1];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
    alertData = [NSArray arrayWithObjects:@"提前一天",@"提前两天",@"提前三天",@"提前四天",@"提前五天",@"提前六天",@"提前七天", nil];
    
    yearData = [[NSMutableArray alloc] init];
//    for (int i = 1930; i < 2030; i++) {
//        [yearData addObject:[NSString stringWithFormat:@"%zd年",i]];
//    }
    
    if (self.rid != nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSDate *date = [formatter dateFromString:self.rdate];
        
        [formatter setDateFormat:@"yyyy"];
        selectDefaultYear = [[formatter stringFromDate:date] intValue];
        [formatter setDateFormat:@"MM"];
        selectDefaultMonth = [[formatter stringFromDate:date] intValue];
        [formatter setDateFormat:@"dd"];
        selectDefaultDay = [[formatter stringFromDate:date] intValue];
    }
    else
    {
        selectDefaultYear = [NSDate date].year;
        selectDefaultMonth = [NSDate date].month;
        selectDefaultDay = [NSDate date].day;
    }
    
    [yearData addObject:[NSString stringWithFormat:@"%zd年",selectDefaultYear]];
    
    nonglimonthData = [NSArray arrayWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月",  @"十月", @"冬月", @"腊月", nil];
    yanglimonthData = [NSArray arrayWithObjects:@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月",  @"10月", @"11月", @"12月", nil];
    
    
    nongliDayData = [NSArray arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", @"三一", nil];
    yangliDayData = [NSArray arrayWithObjects: @"01日", @"02日", @"03日", @"04日", @"05日", @"06日", @"07日", @"08日", @"09日", @"10日", @"11日", @"12日", @"13日", @"14日", @"15日", @"16日", @"17日", @"18日", @"19日", @"20日", @"21日", @"22日", @"23日", @"24日", @"25日", @"26日", @"27日", @"28日", @"29日", @"30日",@"31日", nil];
    EarthlyBranches = [NSArray arrayWithObjects:@"子时 23点",@"子时 0点",@"丑时 1点",@"丑时 2点",@"寅时 3点",@"寅时 4点",@"卯时 5点",@"卯时 6点",@"辰时 7点",@"辰时 8点",@"巳时 9点",@"巳时 10点",@"午时 11点",@"午时 12点",@"未时 13点",@"未时 14点",@"申时 15点",@"申时 16点",@"酉时 17点",@"酉时 18点",@"戌时 19点",@"戌时 20点",@"亥时 21点",@"亥时 22点",nil];
    
    miniteData = [[NSMutableArray alloc] init];
    for (int i = 0; i < 60; i++) {
        [miniteData addObject:[NSString stringWithFormat:@"%2d分",i]];
    }

    selectYear = selectDefaultYear;
    selectMonth = selectDefaultMonth;
    selectDay = selectDefaultDay;

    selectRemind = 1;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50,45)];
    label.text = @"标题";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, FRAME.width, 1)];
    label.backgroundColor = [UIColor colorWithRed:226./256. green:226./256. blue:226./256. alpha:1];
    [self.view addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 46, 50,45)];
    label.text = @"日期";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 91, FRAME.width, 1)];
    label.backgroundColor = [UIColor colorWithRed:226./256. green:226./256. blue:226./256. alpha:1];
    [self.view addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 91, 50,45)];
    label.text = @"提醒";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 136, FRAME.width, 1)];
    label.backgroundColor = [UIColor colorWithRed:226./256. green:226./256. blue:226./256. alpha:1];
    [self.view addSubview:label];
    
    UITextField *nameTextView = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, FRAME.width-50, 45)];
    nameTextView.tag = 1000;
    if (self.rname != nil) {
        nameTextView.text = self.rname;
    }
    nameTextView.placeholder = @"请添加亲友姓名";
    nameTextView.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.view addSubview:nameTextView];
    
    UITextField *timeTextView = [[UITextField alloc] initWithFrame:CGRectMake(80, 46, FRAME.width-50, 45)];
    timeTextView.tag = 10001;
    if (self.rdate != nil) {
        timeTextView.text = self.rdate;
    }
    timeTextView.placeholder = @"请选择亲友日期";
    timeTextView.delegate = self;
    [self.view addSubview:timeTextView];
    
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 91, FRAME.width-50, 45)];
    alertLabel.tag = 10000;
    alertLabel.textColor = [UIColor colorWithRed:72./256. green:72./256. blue:72./250. alpha:1];
    alertLabel.text = @"提前一天";
    alertLabel.userInteractionEnabled = YES;
    [self.view addSubview:alertLabel];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popAlertPicker)];
    [alertLabel addGestureRecognizer:tap2];
    
    
    
    pickerView = [[Pickerview alloc] initWithFrame:CGRectMake(0, FRAME.height, FRAME.width ,300)];
    pickerView.delegate = self;
    pickerView.backgroundColor = [UIColor whiteColor];
    
    
    
    //    NSInteger componentNumber;  //component个数
    //    NSArray *rows;              //每个component有多少项数据
    //    NSArray *titleOfComponent;  //某个component的的某个row的title
    
    pickerView->componentNumber = 1;
    pickerView->rows = [[NSArray alloc] initWithObjects:@7, nil];
    pickerView->titleOfComponent = [[NSArray alloc] initWithObjects:alertData, nil];
    
    [pickerView loadPickerData];
    selectType = 0;
    
    [self.view addSubview:pickerView];
    

    UIBarButtonItem *rightItem = [UIBarButtonItem rsBarButtonItemWithTitle:@"保存" image:nil heightLightImage:nil disableImage:nil target:self action:@selector(savePressed)];
    [self setRightBarButtonItem:rightItem];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)popDatePicker
{
//    NSLog(@"date picker");
    selectType = 1;
    
    pickerView->componentNumber = 3;
    pickerView->rows = [[NSArray alloc] initWithObjects:[NSNumber numberWithInteger:[yearData count]],
                        [NSNumber numberWithInteger:[nonglimonthData count]],
                        [NSNumber numberWithInteger:[nongliDayData count]],
//                        [NSNumber numberWithInteger:[EarthlyBranches count]],
//                        [NSNumber numberWithInteger:[miniteData count]],
                        nil];
    pickerView->titleOfComponent = [[NSArray alloc] initWithObjects:yearData,yanglimonthData,yangliDayData,EarthlyBranches,miniteData, nil];
    [pickerView resetMark];

    
    [pickerView setPickerType:1];
    
    [pickerView->pickerview selectRow:selectDefaultMonth-1 inComponent:1 animated:NO];
    [pickerView->pickerview selectRow:selectDefaultDay-1 inComponent:2 animated:NO];
    [UIView animateWithDuration:.5f animations:^{
        pickerView.frame = CGRectMake(0, FRAME.height-300, FRAME.width ,300);
    }];

}
- (void)popAlertPicker
{
//    NSLog(@"alert picker");
    selectType = 2;
    
    
    pickerView->componentNumber = 1;
    pickerView->rows = [[NSArray alloc] initWithObjects:[NSNumber numberWithInteger:[alertData count]], nil];
    pickerView->titleOfComponent = [[NSArray alloc] initWithObjects:alertData, nil];
    
    
    [pickerView setPickerType:0];
    
    [UIView animateWithDuration:.5f animations:^{
        pickerView.frame = CGRectMake(0, FRAME.height-300, FRAME.width ,300);
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (selectType == 2) {
        UILabel *label = (UILabel *)[self.view viewWithTag:10000];
        label.text = [alertData objectAtIndex:[pickerView selectedRowInComponent:0]];
        selectRemind = [pickerView selectedRowInComponent:0];
    }
    
    UITextField *nameTextView = (UITextField *)[self.view viewWithTag:1000];
    [nameTextView resignFirstResponder];
    
    [self keyboardWillShow];
    selectType = 0;
}

- (void)savePressed
{

    UITextField *textView = (UITextField *)[self.view viewWithTag:1000];
    NSString *name = textView.text;
    if(!name || name.length == 0)
    {
        [self showTimedHUD:YES message:@"请输入亲友姓名"];
        return;
    }
    
    UITextField* time = (UITextField*)[self.view viewWithTag:10001];
    if(!time.text || time.text.length == 0)
    {
        [self showTimedHUD:YES message:@"请输入亲友日期"];
        return;
    }
    
    int remind = [pickerView selectedRowInComponent:0] + 1;
    if(remind != selectRemind)
    {
        selectRemind = remind;
        UITextField *nameTextView = (UITextField *)[self.view viewWithTag:1000];
        [nameTextView resignFirstResponder];
    }
    
    if (self.rid == nil) {
    
        [CalendarDataSource addCalendarRemindDo:0 WithRname:name Rdate:[NSString stringWithFormat:@"%zd-%.2zd-%.2zd",selectYear,selectMonth,selectDay] Rtime:selectRemind Rtype:
         pickerView->yangliSelected?0:1 success:^(id obj) {
                [self alertShow:[obj objectForKey:@"msg"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCalendar" object:nil];
        } failed:^(ExError* error) {
            [self alertShow:error.titleForError];
        }];
    }
    else
    {
        [CalendarDataSource modifyCalendarRemindDo:0 WithRname:name Rdate:[NSString stringWithFormat:@"%zd-%.2zd-%.2zd",selectYear,selectMonth,selectDay] Rtime:selectRemind Crid:[self.rid intValue] success:^(id obj)
        {
                [self alertShow:[obj objectForKey:@"msg"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCalendar" object:nil];
        } failed:^(ExError* error) {
            [self alertShow:error.titleForError];
        }];
    }
}
- (void)ButtonPressed:(int)index
{
    
    if(index == 0)
    {
        pickerView->titleOfComponent = [[NSArray alloc] initWithObjects:yearData,yanglimonthData,yangliDayData,EarthlyBranches,miniteData, nil];
        [pickerView reloadPicker];
    }
    else if (index == 1)
    {
        pickerView->titleOfComponent = [[NSArray alloc] initWithObjects:yearData,nonglimonthData,nongliDayData,EarthlyBranches,miniteData, nil];
        [pickerView reloadPicker];
    }
    else
    {
        NSMutableString *str = [[NSMutableString alloc] init];
        NSArray *yangliArray = [NSArray arrayWithObjects:yearData,yanglimonthData,yangliDayData,EarthlyBranches,miniteData, nil];
        NSArray *nongliArray = [NSArray arrayWithObjects:yearData,nonglimonthData,nongliDayData,EarthlyBranches,miniteData, nil];
        
        if (pickerView->yangliSelected == 1) {

            for (int i = 0; i < 3; i++) {
                [str appendString:[[yangliArray objectAtIndex:i] objectAtIndex:[pickerView selectedRowInComponent:i]]];
            }
            
        }
        else
        {
            for (int i = 0; i < 3; i++) {
                [str appendString:[[nongliArray objectAtIndex:i] objectAtIndex:[pickerView selectedRowInComponent:i]]];
            }
        }
        
        selectYear = [pickerView selectedRowInComponent:0]+selectDefaultYear;
        selectMonth = [pickerView selectedRowInComponent:1]+1;
        selectDay = [pickerView selectedRowInComponent:2]+1;
        
        UITextField *timeTextFiled = (UITextField *)[self.view viewWithTag:10001];
        timeTextFiled.text = str;
        
        
        [UIView animateWithDuration:.5f animations:^{
            pickerView.frame = CGRectMake(0, FRAME.height, FRAME.width ,300);
        }];
        
        selectType = 0;
    
    }

}

- (void)keyboardWillShow
{
    selectType = 0;
    [UIView animateWithDuration:.5f animations:^{
        pickerView.frame = CGRectMake(0, FRAME.height, FRAME.width ,300);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertShow:(NSString *)str
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    if(textField.tag == 10001)
    {
        [self popDatePicker];
        return NO;
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
