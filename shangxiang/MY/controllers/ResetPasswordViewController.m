//
//  ResetPasswordViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/11.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "MyRequestManager.h"
#import "InputVeryCodeViewController.h"


@interface ResetPasswordViewController ()
{
    UILabel* _mobileDescription;
    UITextField* _mobileTextFiled;
}
@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"密码重置";
    self.view.backgroundColor = UIColorFromRGB(COLOR_BG_NORMAL);
    [self setupForDismissKeyboard];
    
    _mobileDescription = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.width - 20, 50)];
    _mobileDescription.text = @"请输入申请账号时的手机号码";
    _mobileDescription.font = [UIFont systemFontOfSize:15];
    _mobileDescription.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    [self.view addSubview:_mobileDescription];
    
    UIView* mobileSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, _mobileDescription.bottom, self.view.width, 50)];
    [mobileSuperView setBackgroundColor:[UIColor clearColor]];
    [mobileSuperView.layer setBorderWidth:0.5];
    [mobileSuperView.layer setBorderColor:UIColorFromRGB(COLOR_LINE_NORMAL).CGColor];
    [self.view addSubview:mobileSuperView];
    
    _mobileTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, self.view.width - 20, 50)];
    _mobileTextFiled.keyboardType = UIKeyboardTypeASCIICapable;
    _mobileTextFiled.autocapitalizationType = NO;
    _mobileTextFiled.returnKeyType = UIReturnKeyDone;
    _mobileTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _mobileTextFiled.leftViewMode = UITextFieldViewModeAlways;
    _mobileTextFiled.backgroundColor = [UIColor clearColor];
    _mobileTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mobileTextFiled.font = [UIFont systemFontOfSize:15];
    _mobileTextFiled.placeholder = @"请输入手机号";
    [mobileSuperView addSubview:_mobileTextFiled];
    
    
    UIButton* buttonSubmitCreateOrder = [[UIButton alloc] initWithFrame:CGRectMake(20, mobileSuperView.bottom + 20, self.view.width - 40, 40)];
    [buttonSubmitCreateOrder setTitle:@"下一步" forState:UIControlStateNormal];
    [buttonSubmitCreateOrder.layer setCornerRadius:3];
    [buttonSubmitCreateOrder setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [buttonSubmitCreateOrder setBackgroundColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_HIGHLIGHT)];
    [buttonSubmitCreateOrder setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_PRESSED)] forState:UIControlStateHighlighted];
    [buttonSubmitCreateOrder addTarget:self action:@selector(submitCreateOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSubmitCreateOrder];
    
}

- (void)submitCreateOrder
{
    if(!_mobileTextFiled.text || _mobileTextFiled.text.length == 0)
    {
        [self showTimedHUD:YES message:@"手机号不能为空"];
        return;
    }
    
    [self showChrysanthemumHUD:YES];
    typeof(self) weakSelf = self;
    [MyRequestManager sendMobileMessage:_mobileTextFiled.text successBlock:^(id obj) {
        [weakSelf removeAllHUDViews:YES];
        
        InputVeryCodeViewController* inputViewController = [[InputVeryCodeViewController alloc] init];
        inputViewController.mobile = weakSelf->_mobileTextFiled.text;
        inputViewController.code = [obj stringForKey:@"msg" withDefault:@""];
        [weakSelf.navigationController pushViewController:inputViewController animated:YES];
        
    } failed:^(id error) {
        [weakSelf removeAllHUDViews:YES];
        [weakSelf dealWithError:error];
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
