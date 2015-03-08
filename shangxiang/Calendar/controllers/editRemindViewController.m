//
//  editRemindViewController.m
//  shangxiang
//
//  Created by 刘佳男 on 15/2/3.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "editRemindViewController.h"
#import "CalendarDataSource.h"
#import "AddBirthdayViewController.h"

@interface editRemindViewController ()<UIAlertViewDelegate>
{
    NSString *remindName;
    NSString *remindDate;
    NSInteger remindId;
}
@end

@implementation editRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    self.view.backgroundColor = [UIColor colorWithRed:240./256. green:240./256. blue:240./256. alpha:1];
    [self setupForDismissKeyboard];
    
    UIImage *image = [UIImage imageForKey:@"remindImage"];
    UIImageView *remindBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200.*568./self.view.frame.size.height)];
    remindBg.image = image;
    [remindBg setContentMode:UIViewContentModeScaleToFill];
    [self.view addSubview:remindBg];
    
    float orgin_y = remindBg.frame.size.height+10;
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSArray *remindArray = [def objectForKey:@"remindArray"];

    if(remindArray && remindArray.count > 0)
    {
        for (NSDictionary *dic in remindArray) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"reminddate"] integerValue]];
            if ((self.selectDate.year == date.year) &&
                (self.selectDate.month == date.month) &&
                (self.selectDate.day == date.day)) {
                remindName = [dic stringForKey:@"relativesname" withDefault:@""];
                remindId = [dic intForKey:@"id" withDefault:0];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy年MM月dd日"];
                remindDate = [formatter stringFromDate:date];
            }
        }
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, orgin_y, self.view.frame.size.width-20, 30)];
    label.text = [remindName stringByAppendingString:@"的生日"];
    label.textColor = [UIColor colorWithRed:95./255. green:95./255. blue:95./255. alpha:1];
    label.font = [UIFont systemFontOfSize:20.];
    [self.view addSubview:label];
    
    orgin_y += 30;
    
    UIImageView* timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, orgin_y + 7, 15, 15)];
    [timeImageView setImage:[UIImage imageForKey:@"calendar_detail_time"]];
    [self.view addSubview:timeImageView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(timeImageView.right + 5, orgin_y, self.view.frame.size.width-15 - timeImageView.right, 30)];
    label.text = remindDate;
    label.font = [UIFont systemFontOfSize:18.];
    label.textColor = [UIColor colorWithRed:170./255. green:170./255. blue:170./255. alpha:1];
    [self.view addSubview:label];
    
    orgin_y += 30;
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, label.bottom - 0.5, self.view.width, 0.5)];
    [lineView setBackgroundColor:UIColorFromRGB(COLOR_LINE_NORMAL)];
    [self.view addSubview:lineView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, orgin_y, self.view.frame.size.width/2., 50);
    btn.tag = 10086;
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:95./255. green:95./255. blue:95./255. alpha:1] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xEBEBEB)] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.frame.size.width/2., orgin_y, self.view.frame.size.width/2., 50);
    btn.tag = 10087;
    [btn setTitle:@"求愿" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:95./255. green:95./255. blue:95./255. alpha:1] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, btn.bottom, self.view.width, 0.5)];
    [lineView setBackgroundColor:UIColorFromRGB(COLOR_LINE_NORMAL)];
    [self.view addSubview:lineView];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(self.view.frame.size.width-60, label.frame.origin.y, 30, 30);
    btn.tag = 10088;
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:170./255. green:170./255. blue:170./255. alpha:1] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTintColor:[UIColor colorWithRed:235./255. green:235./255. blue:235./255. alpha:1]];
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}


- (void)btnPressed:(UIButton *)btn
{
    if (btn.tag == 10086) {
        AddBirthdayViewController *ABVC = [[AddBirthdayViewController alloc] init];
        ABVC.rid = [[NSNumber alloc] initWithInteger:remindId];
        ABVC.rname = [[NSString alloc] initWithString:remindName];
        ABVC.rdate = [[NSString alloc] initWithString:remindDate];
        [self.navigationController pushViewController:ABVC animated:YES];
    }
    else if(btn.tag == 10087)
    {
        [APPNAVGATOR calendarTurnWillingGuide];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定删除“%@”吗？",remindName] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        [alert show];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)alertShow:(NSString *)str
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    alert.tag = 10000;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10000) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if (buttonIndex == 1) {
            //删除
            [CalendarDataSource deleteCalendarRemindDo:remindId  success:^(id obj)
            {
                [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:@"reloadCalendar" object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self alertShow:[obj objectForKey:@"msg"]];
                });
                
            } failed:^(ExError* error) {
                [self alertShow:error.titleForError];
            }];
        }
    }
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
