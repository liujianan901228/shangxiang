//
//  ResetChangePasswordViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/25.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "ResetChangePasswordViewController.h"
#import "MyRequestManager.h"

@interface ResetChangePasswordViewController ()
{
    //UILabel* _mobileDescription;
    UITextField* _mobileTextFiled;
}
@end

@implementation ResetChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"密码重置";
    self.view.backgroundColor = UIColorFromRGB(COLOR_BG_NORMAL);
    [self setupForDismissKeyboard];
    
//    _mobileDescription = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.width - 20, 50)];
//    _mobileDescription.text = @"请输入你的密码";
//    _mobileDescription.font = [UIFont systemFontOfSize:15];
//    _mobileDescription.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
//    [self.view addSubview:_mobileDescription];
    
    UIView* mobileSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 50)];
    [mobileSuperView setBackgroundColor:[UIColor clearColor]];
    [mobileSuperView.layer setBorderWidth:0.5];
    [mobileSuperView.layer setBorderColor:UIColorFromRGB(COLOR_LINE_NORMAL).CGColor];
    [self.view addSubview:mobileSuperView];
    
    _mobileTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, self.view.width - 20, 50)];
    _mobileTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    _mobileTextFiled.autocapitalizationType = NO;
    _mobileTextFiled.returnKeyType = UIReturnKeyDone;
    _mobileTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _mobileTextFiled.leftViewMode = UITextFieldViewModeAlways;
    _mobileTextFiled.backgroundColor = [UIColor clearColor];
    _mobileTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mobileTextFiled.font = [UIFont systemFontOfSize:15];
    _mobileTextFiled.placeholder = @"请输入密码";
    [mobileSuperView addSubview:_mobileTextFiled];
    
    
    UIButton* buttonSubmitCreateOrder = [[UIButton alloc] initWithFrame:CGRectMake(20, mobileSuperView.bottom + 20, self.view.width - 40, 40)];
    [buttonSubmitCreateOrder setTitle:@"下一步" forState:UIControlStateNormal];
    [buttonSubmitCreateOrder.layer setCornerRadius:3];
    [buttonSubmitCreateOrder setClipsToBounds:YES];
    [buttonSubmitCreateOrder setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [buttonSubmitCreateOrder setBackgroundColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_NORMAL)];
    [buttonSubmitCreateOrder setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_HIGHLIGHT)] forState:UIControlStateHighlighted];
    [buttonSubmitCreateOrder addTarget:self action:@selector(submitCreateOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSubmitCreateOrder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)submitCreateOrder
{
    if(!_mobileTextFiled.text || _mobileTextFiled.text.length == 0)
    {
        [self showTimedHUD:YES message:@"密码不能为空"];
        return;
    }
    
    [self showChrysanthemumHUD:YES];
    typeof(self) weakSelf = self;
    [MyRequestManager ResetChangeMobileMessage:self.mobile password:_mobileTextFiled.text successBlock:^(id obj) {
        [weakSelf showTimedHUD:YES message:[obj stringForKey:@"msg" withDefault:@""]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
    } failed:^(id error) {
        [weakSelf removeAllHUDViews:YES];
        [weakSelf dealWithError:error];
    }];
}

@end
