//
//  RegisterViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/11.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginRequestManager.h"

@interface RegisterViewController ()<UITextFieldDelegate>
{
    UITextField* _fieldUsername;
    UITextField* _fieldPassword;
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    self.view.backgroundColor = UIColorFromRGB(COLOR_BG_NORMAL);
    
    [self setupForDismissKeyboard];
    
    UIView* cell1 = [[UIView alloc] initWithFrame:CGRectMake(0, 22, self.view.width, 44)];
    [cell1 setBackgroundColor:[UIColor clearColor]];
    [cell1.layer setBorderColor:UIColorFromRGB(COLOR_LINE_NORMAL).CGColor];
    [cell1.layer setBorderWidth:HEIGHT_LINE];
    

    UILabel* labelUsername = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 50, cell1.height)];
    labelUsername.text = @"帐号：";
    labelUsername.font = [UIFont systemFontOfSize:15];
    labelUsername.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    [cell1 addSubview:labelUsername];
    
    _fieldUsername = [[UITextField alloc] initWithFrame:CGRectMake(labelUsername.right, 0, cell1.width - labelUsername.right, 44)];
    _fieldUsername.autocapitalizationType = NO;
    _fieldUsername.keyboardType = UIKeyboardTypeNumberPad;
    _fieldUsername.returnKeyType = UIReturnKeyNext;
    _fieldUsername.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _fieldUsername.leftViewMode = UITextFieldViewModeAlways;
    _fieldUsername.placeholder = @"请输入手机号";
    _fieldUsername.delegate = self;
    [cell1 addSubview:_fieldUsername];
    
    
    UIView* cell2 = [[UIView alloc] initWithFrame:CGRectMake(0, cell1.bottom, self.view.width, 44)];
    [cell2 setBackgroundColor:[UIColor clearColor]];
    [cell2.layer setBorderColor:UIColorFromRGB(COLOR_LINE_NORMAL).CGColor];
    [cell2.layer setBorderWidth:HEIGHT_LINE];
    
    
    UILabel* labelPassword = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 50, cell1.height)];
    labelPassword.text = @"密码：";
    labelPassword.font = [UIFont systemFontOfSize:15];
    labelPassword.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    [cell2 addSubview:labelPassword];
    
    _fieldPassword = [[UITextField alloc] initWithFrame:CGRectMake(labelUsername.right, 0, cell1.width - labelUsername.right, 44)];
    _fieldPassword.secureTextEntry = YES;
    _fieldPassword.autocapitalizationType = NO;
    _fieldPassword.returnKeyType = UIReturnKeyDone;
    _fieldPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _fieldPassword.leftViewMode = UITextFieldViewModeAlways;
    _fieldPassword.backgroundColor = [UIColor clearColor];
    _fieldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    _fieldPassword.font = [UIFont systemFontOfSize:15];
    _fieldPassword.placeholder = @"请输入密码";
    _fieldPassword.delegate = self;
    
    [cell2 addSubview:_fieldPassword];
    
    
    
    UIButton* buttonSubmitRegister = [[UIButton alloc] initWithFrame:CGRectMake(20, cell2.bottom + 20, self.view.width - 20*2, 40)];
    [buttonSubmitRegister setTitle:@"立即注册" forState:UIControlStateNormal];
    [buttonSubmitRegister.layer setCornerRadius:3];
    [buttonSubmitRegister setClipsToBounds:YES];
    [buttonSubmitRegister setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [buttonSubmitRegister setBackgroundColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_NORMAL)];
    [buttonSubmitRegister setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_HIGHLIGHT)] forState:UIControlStateHighlighted];
    [buttonSubmitRegister addTarget:self action:@selector(submitRegister) forControlEvents:UIControlEventTouchUpInside];
  
    [self.view addSubview:cell1];
    [self.view addSubview:cell2];
    [self.view addSubview:buttonSubmitRegister];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitRegister
{
    BOOL bolValid = YES;
    if (_fieldUsername.text.length < 2)
    {
        bolValid = NO;
        [self showTimedHUD:YES message:@"请输入正确的手机号"];
    }
    if (bolValid && _fieldUsername.text.length < 1)
    {
        bolValid = NO;
        [self showTimedHUD:YES message:@"请输入正确的密码"];
    }
    if (bolValid)
    {
        [self showChrysanthemumHUD:YES];
        
        typeof(self) weakSelf = self;
        [LoginRequestManager postRegister:_fieldUsername.text andPassword:_fieldPassword.text success:^(id obj) {
            [weakSelf removeAllHUDViews:NO];
            [weakSelf showTimedHUD:YES message:[obj objectForKey:@"msg"]];
            
            if(!USEROPERATIONHELP.currentUser)
            {
                AppUser* user = [[AppUser alloc] initWithDic:[obj objectForKey:@"memberinfo"]];
                USEROPERATIONHELP.currentUser = user;
                USEROPERATIONHELP.currentUser.isLogined = YES;
                [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:AppUserLoginNotification object:nil];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf goBack];
            });
            
        } failed:^(id error) {
            [weakSelf removeAllHUDViews:NO];
            [weakSelf dealWithError:error];
        }];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if (textField.returnKeyType == UIReturnKeyNext) {
        [_fieldPassword becomeFirstResponder];
    }
    if (textField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
    }
    return YES;
}


@end
