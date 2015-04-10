//
//  SettingsViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/13.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "SettingsViewController.h"
#import "MyRequestManager.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    self.view.backgroundColor = UIColorFromRGB(COLOR_BG_NORMAL);
    
    UIView* fristView = [[UIView alloc] initWithFrame:CGRectMake(-1, 20, self.view.width + 2, 44)];
    fristView.backgroundColor = UIColorFromRGB(COLOR_BG_HIGHLIGHT);
    fristView.layer.borderColor = UIColorFromRGB(COLOR_LINE_NORMAL).CGColor;
    fristView.layer.borderWidth = 0.5;
    
    UILabel* lable1 = [[UILabel alloc] initWithFrame:CGRectMake(10, (fristView.height - 30)/2, 200, 30)];
    lable1.font = [UIFont systemFontOfSize:15];
    lable1.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    lable1.text = @"佛历提醒";
    [fristView addSubview:lable1];
    
    UISwitch* swith1 = [[UISwitch alloc] initWithFrame:CGRectMake(fristView.width - 10 - 50, (fristView.height - 30)/2, 50, 30)];
    [fristView addSubview:swith1];
    [swith1 setOn:USEROPERATIONHELP.currentUser.isRemind];
    [swith1 addTarget:self action:@selector(remindSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fristView];
    
    //////////////////////////////////
    UIView* fristView2 = [[UIView alloc] initWithFrame:CGRectMake(-1, fristView.bottom + 20, self.view.width + 2, 44)];
    fristView2.backgroundColor = UIColorFromRGB(COLOR_BG_HIGHLIGHT);
    fristView2.layer.borderColor = UIColorFromRGB(COLOR_LINE_NORMAL).CGColor;
    fristView2.layer.borderWidth = 0.5;
     
    UILabel* lable2 = [[UILabel alloc] initWithFrame:CGRectMake(10, (fristView2.height - 30)/2, 200, 30)];
    lable2.font = [UIFont systemFontOfSize:15];
    lable2.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    lable2.text = @"获取当前地理位置";
    [fristView2 addSubview:lable2];
    
    UISwitch* swith2 = [[UISwitch alloc] initWithFrame:CGRectMake(fristView2.width - 10 - 50, (fristView2.height - 30)/2, 50, 30)];
    [swith2 setOn:YES];
    [fristView2 addSubview:swith2];
    
    [self.view addSubview:fristView2];
    /////////////////////////////////
   
    
}

- (void)remindSwitch:(UISwitch*)remindSwitch
{
    [self showChrysanthemumHUD:YES];
    __weak typeof(self) weakSelf = self;
    [MyRequestManager getFoliRemind:remindSwitch.isOn success:^(id obj) {
        [weakSelf removeAllHUDViews:YES];
        [weakSelf showTimedHUD:YES message:[obj objectForKey:@"msg"]];
    } failed:^(id error) {
        [weakSelf removeAllHUDViews:YES];
        [weakSelf dealWithError:error];
        [remindSwitch setOn:USEROPERATIONHELP.currentUser.isRemind];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
