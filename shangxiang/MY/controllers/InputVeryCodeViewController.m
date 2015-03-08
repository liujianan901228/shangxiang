//
//  InputVeryCodeViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/25.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "InputVeryCodeViewController.h"
#import "MyRequestManager.h"
#import "ResetChangePasswordViewController.h"

@interface InputVeryCodeViewController ()
{
    UILabel* _mobileDescription;
    UITextField* _fieldVerfyCode;
    UIButton* _buttonResendVerfyCode;
    NSTimer* _timer;
    NSInteger _currentTime;
}

@end

@implementation InputVeryCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"填写验证码";
    self.view.backgroundColor = UIColorFromRGB(COLOR_BG_NORMAL);
    [self setupForDismissKeyboard];
    
    _mobileDescription = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.width - 20, 50)];
    NSString* showText = [NSString stringWithFormat:@"验证码已发送至%@",self.mobile];
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:showText];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:[showText rangeOfString:self.mobile]];
    [_mobileDescription setAttributedText:attributedString];
    _mobileDescription.font = [UIFont systemFontOfSize:15];
    _mobileDescription.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    [self.view addSubview:_mobileDescription];
    
    _fieldVerfyCode = [[UITextField alloc] initWithFrame:CGRectMake(20, _mobileDescription.bottom,130, 40)];
    [_fieldVerfyCode setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)]];
    _fieldVerfyCode.keyboardType = UIKeyboardTypeASCIICapable;
    _fieldVerfyCode.autocapitalizationType = NO;
    _fieldVerfyCode.returnKeyType = UIReturnKeyDone;
    _fieldVerfyCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _fieldVerfyCode.leftViewMode = UITextFieldViewModeAlways;
    _fieldVerfyCode.backgroundColor = [UIColor clearColor];
    _fieldVerfyCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    _fieldVerfyCode.font = [UIFont systemFontOfSize:15];
    _fieldVerfyCode.placeholder = @"请输入验证码";
    [_fieldVerfyCode.layer setBorderWidth:0.5];
    [_fieldVerfyCode.layer setBorderColor:UIColorFromRGB(COLOR_LINE_NORMAL).CGColor];
    [self.view addSubview:_fieldVerfyCode];
    
    _currentTime = 60;
    _buttonResendVerfyCode = [[UIButton alloc] initWithFrame:CGRectMake(_fieldVerfyCode.right + 10, _mobileDescription.bottom, 130, 40)];
    _buttonResendVerfyCode.titleLabel.font = [UIFont systemFontOfSize:15];
    [_buttonResendVerfyCode setTitle:[NSString stringWithFormat:@"重新发送？(%zd)",_currentTime] forState:UIControlStateNormal];
    [_buttonResendVerfyCode setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [_buttonResendVerfyCode setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_PRESSED)] forState:UIControlStateDisabled];
    [_buttonResendVerfyCode setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_HIGHLIGHT)] forState:UIControlStateNormal];
    [_buttonResendVerfyCode setEnabled:NO];
    [_buttonResendVerfyCode addTarget:self action:@selector(resendVerfyCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonResendVerfyCode];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:[YYWeakProxy proxyWithTarget:self] selector:@selector(onTimter) userInfo:nil repeats:YES];
    
    
    UIButton* buttonSubmitCreateOrder = [[UIButton alloc] initWithFrame:CGRectMake(20, _buttonResendVerfyCode.bottom + 20, self.view.width - 40, 40)];
    [buttonSubmitCreateOrder setTitle:@"下一步" forState:UIControlStateNormal];
    [buttonSubmitCreateOrder.layer setCornerRadius:3];
    [buttonSubmitCreateOrder setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [buttonSubmitCreateOrder setBackgroundColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_HIGHLIGHT)];
    [buttonSubmitCreateOrder setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_PRESSED)] forState:UIControlStateHighlighted];
    [buttonSubmitCreateOrder addTarget:self action:@selector(submitCreateOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSubmitCreateOrder];
    
}

- (void)resendVerfyCode
{
    [self showChrysanthemumHUD:YES];
    typeof(self) weakSelf = self;

    [MyRequestManager sendMobileMessage:self.mobile successBlock:^(id obj) {
        [weakSelf removeAllHUDViews:YES];
        weakSelf.code = [obj stringForKey:@"msg" withDefault:@""];
        weakSelf->_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:[YYWeakProxy proxyWithTarget:weakSelf] selector:@selector(onTimter) userInfo:nil repeats:YES];
        weakSelf->_currentTime = 60;
        [_buttonResendVerfyCode setTitle:[NSString stringWithFormat:@"重新发送？(%zd)",_currentTime] forState:UIControlStateNormal];
        [weakSelf->_buttonResendVerfyCode setEnabled:NO];
    } failed:^(id error) {
        [weakSelf removeAllHUDViews:YES];
        [weakSelf dealWithError:error];
    }];
}

- (void)submitCreateOrder
{
    if(!_fieldVerfyCode.text || _fieldVerfyCode.text.length == 0)
    {
        [self showTimedHUD:YES message:@"验证码不能为空"];
        return;
    }
    
    if([_fieldVerfyCode.text isEqualToString:self.code])
    {
        ResetChangePasswordViewController* controller = [[ResetChangePasswordViewController alloc] init];
        controller.mobile = self.mobile;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        [self showTimedHUD:YES message:@"您输入的验证码不正确"];
        return;
    }
}

- (void)onTimter
{
    _currentTime -- ;
    if(_currentTime <= 0)
    {
        _currentTime = 60;
        [_buttonResendVerfyCode setEnabled:YES];
        [_buttonResendVerfyCode setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
        [_timer invalidate];
        _timer = nil;
        return;
    }
    [_buttonResendVerfyCode setTitle:[NSString stringWithFormat:@"重新发送？(%zd)",_currentTime] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}


@end
