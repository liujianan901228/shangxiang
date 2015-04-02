//
//  LoginViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/11.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "LoginRequestManager.h"
#import "ResetPasswordViewController.h"
#import "WXApi.h"
#import "CustomRowButton.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField* fieldCur;
    UITextField* fieldUsername;
    UITextField* fieldPassword;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    self.view.backgroundColor = UIColorFromRGB(COLOR_BG_NORMAL);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webLogin:) name:WebLoginNotification object:nil];
    
    float fltViewWidth = CGRectGetWidth(self.view.bounds);
    float fltViewHeight = CGRectGetHeight(self.view.bounds);
    float fltInputHeight = 44;
    int fltMargin = 20;
    float fltStatusBarHeight = 20;

    
    UIView* viewMain = [[UIView alloc] initWithFrame:self.view.frame];
    [self setupForDismissKeyboard];
    
    CGRect frame = CGRectZero;
    float fltBegin = fltStatusBarHeight;
    
    UIImage* imgClose = [UIImage imageForKey:@"close"];
    CustomRowButton* rowbutton = [[CustomRowButton alloc] initWithFrame:CGRectMake(self.view.width - 60, fltBegin + 10, 60, 30)];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake((rowbutton.width - imgClose.size.width)/2, (rowbutton.height - imgClose.size.height)/2, imgClose.size.width, imgClose.size.height)];
    [imageView setImage:imgClose];
    [rowbutton addSubview:imageView];
    [rowbutton addTarget:self action:@selector(customGoBack) forControlEvents:UIControlEventTouchUpInside];
    [viewMain addSubview:rowbutton];
    fltBegin += 38;
    
    UIImage* imgLogo = [UIImage imageForKey:@"logo"];
    frame.origin = CGPointMake((fltViewWidth - imgLogo.size.width) / 2, fltBegin);
    frame.size = imgLogo.size;
    UIImageView* viewLogo = [[UIImageView alloc] initWithFrame:frame];
    viewLogo.image = imgLogo;
    [viewMain addSubview:viewLogo];
    
    fltBegin += 84;
    
    frame.origin = CGPointMake(0, fltBegin);
    frame.size = CGSizeMake(fltViewWidth, HEIGHT_LINE);
    UIView* viewTemp = [[UIView alloc] initWithFrame:frame];
    viewTemp.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
    [viewMain addSubview:viewTemp];
    
    frame.origin = CGPointMake(fltMargin, fltBegin);
    frame.size = CGSizeMake(fltViewWidth - fltMargin * 2, fltInputHeight);
    UILabel* labelUsername = [[UILabel alloc] initWithFrame:frame];
    labelUsername.text = @"帐号：";
    labelUsername.font = [UIFont systemFontOfSize:15];
    labelUsername.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    [viewMain addSubview:labelUsername];
    
    fieldUsername = [[UITextField alloc] initWithFrame:frame];
    fieldUsername.keyboardType = UIKeyboardTypeASCIICapable;
    fieldUsername.autocapitalizationType = NO;
    fieldUsername.returnKeyType = UIReturnKeyNext;
    fieldUsername.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    fieldUsername.leftViewMode = UITextFieldViewModeAlways;
    fieldUsername.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fltInputHeight, fltInputHeight)];
    fieldUsername.backgroundColor = [UIColor clearColor];
    fieldUsername.clearButtonMode = UITextFieldViewModeWhileEditing;
    fieldUsername.font = [UIFont systemFontOfSize:15];
    fieldUsername.placeholder = @"请输入手机号";
    fieldUsername.delegate = self;
    [viewMain addSubview:fieldUsername];
    
    fltBegin += fltInputHeight;
    
    frame.origin = CGPointMake(0, fltBegin);
    frame.size = CGSizeMake(fltViewWidth, HEIGHT_LINE);
    viewTemp = [[UIView alloc] initWithFrame:frame];
    viewTemp.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
    [viewMain addSubview:viewTemp];
    
    frame.origin = CGPointMake(fltMargin, fltBegin);
    frame.size = CGSizeMake(fltViewWidth - fltMargin - 80, fltInputHeight);
    UILabel* labelPassword = [[UILabel alloc] initWithFrame:frame];
    labelPassword.text = @"密码：";
    labelPassword.font = [UIFont systemFontOfSize:15];
    labelPassword.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    [viewMain addSubview:labelPassword];
    
    fieldPassword = [[UITextField alloc] initWithFrame:frame];
    fieldPassword.secureTextEntry = YES;
    fieldPassword.autocapitalizationType = NO;
    fieldPassword.returnKeyType = UIReturnKeyDone;
    fieldPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    fieldPassword.leftViewMode = UITextFieldViewModeAlways;
    fieldPassword.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fltInputHeight, fltInputHeight)];
    fieldPassword.backgroundColor = [UIColor clearColor];
    fieldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    fieldPassword.font = [UIFont systemFontOfSize:15];
    fieldPassword.placeholder = @"请输入密码";
    fieldPassword.delegate = self;
    [viewMain addSubview:fieldPassword];
    
    frame.origin = CGPointMake(fltViewWidth - 80, fltBegin);
    frame.size = CGSizeMake(80, fltInputHeight);
    UIButton* buttonResetPassword = [[UIButton alloc] initWithFrame:frame];
    buttonResetPassword.titleLabel.font = [UIFont systemFontOfSize:15];
    [buttonResetPassword setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [buttonResetPassword setTitleColor:UIColorFromRGB(COLOR_FONT_NORMAL) forState:UIControlStateNormal];
    [buttonResetPassword setBackgroundColor:[UIColor clearColor]];
    [buttonResetPassword addTarget:self action:@selector(goResetPassword) forControlEvents:UIControlEventTouchUpInside];
    [viewMain addSubview:buttonResetPassword];
    
    fltBegin += fltInputHeight - HEIGHT_LINE;
    
    frame.origin = CGPointMake(0, fltBegin);
    frame.size = CGSizeMake(fltViewWidth, HEIGHT_LINE);
    viewTemp = [[UIView alloc] initWithFrame:frame];
    viewTemp.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
    [viewMain addSubview:viewTemp];
    
    fltBegin += 17;
    float fltButtonWidth = 128;
    float fltButtonHeight = 40;
    
    frame.origin = CGPointMake(fltMargin, fltBegin);
    frame.size = CGSizeMake(fltButtonWidth, fltButtonHeight);
    UIButton* buttonGoRegister = [[UIButton alloc] initWithFrame:frame];
    [buttonGoRegister setTitle:@"注册" forState:UIControlStateNormal];
    [buttonGoRegister.layer setCornerRadius:3];
    [buttonGoRegister setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [buttonGoRegister setBackgroundColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_PRESSED)];
    [buttonGoRegister addTarget:self action:@selector(goRegister) forControlEvents:UIControlEventTouchUpInside];
    [viewMain addSubview:buttonGoRegister];
    
    frame.origin = CGPointMake(fltViewWidth - fltMargin - fltButtonWidth, fltBegin);
    frame.size = CGSizeMake(fltButtonWidth, fltButtonHeight);
    UIButton* buttonSubmitLogin = [[UIButton alloc] initWithFrame:frame];
    [buttonSubmitLogin setTitle:@"登录" forState:UIControlStateNormal];
    [buttonSubmitLogin.layer setCornerRadius:3];
    [buttonSubmitLogin setClipsToBounds:YES];
    [buttonSubmitLogin setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [buttonSubmitLogin setBackgroundColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_NORMAL)];
    [buttonSubmitLogin setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_HIGHLIGHT)] forState:UIControlStateHighlighted];
    [buttonSubmitLogin addTarget:self action:@selector(submitLogin) forControlEvents:UIControlEventTouchUpInside];
    [viewMain addSubview:buttonSubmitLogin];
    
    frame.origin = CGPointMake(0, fltViewHeight - 150);
    frame.size = CGSizeMake(fltViewWidth, 0.5f);
    viewTemp = [[UIView alloc] initWithFrame:frame];
    viewTemp.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
    [viewMain addSubview:viewTemp];
    
    frame.origin = CGPointMake((fltViewWidth - 120) / 2, fltViewHeight - 170);
    frame.size = CGSizeMake(120, 40);
    UILabel* labelPartnerLogin = [[UILabel alloc] initWithFrame:frame];
    labelPartnerLogin.text = @"使用合作账号登录";
    labelPartnerLogin.font = [UIFont systemFontOfSize:12.0f];
    labelPartnerLogin.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    labelPartnerLogin.backgroundColor = UIColorFromRGB(COLOR_BG_NORMAL);
    labelPartnerLogin.textAlignment = NSTextAlignmentCenter;
    [viewMain addSubview:labelPartnerLogin];
    
    UIImage* imgWechat = [UIImage imageForKey:@"logo_wechat"];
    frame.origin = CGPointMake(fltViewWidth / 2 - imgWechat.size.width - 30, fltViewHeight - 120);
    frame.size = imgWechat.size;
    UIImageView* viewWechat = [[UIImageView alloc] initWithFrame:frame];
    viewWechat.image = imgWechat;
    [viewMain addSubview:viewWechat];
    
    UIImage* imgWeibo = [UIImage imageForKey:@"logo_weibo"];
    frame.origin = CGPointMake(fltViewWidth / 2 + 30, fltViewHeight - 120);
    frame.size = imgWeibo.size;
    UIImageView* viewWeibo = [[UIImageView alloc] initWithFrame:frame];
    viewWeibo.image = imgWeibo;
    [viewMain addSubview:viewWeibo];
    
    frame.origin = CGPointMake(viewWechat.frame.origin.x, viewWechat.frame.origin.y + imgWechat.size.height);
    frame.size = CGSizeMake(imgWechat.size.width, 30);
    UILabel* labelWechat = [[UILabel alloc] initWithFrame:frame];
    labelWechat.text = @"微信";
    labelWechat.font = [UIFont systemFontOfSize:14];
    labelWechat.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    labelWechat.textAlignment = NSTextAlignmentCenter;
    [viewMain addSubview:labelWechat];
    
    frame.origin = CGPointMake(viewWeibo.frame.origin.x, viewWeibo.frame.origin.y + imgWeibo.size.height);
    frame.size = CGSizeMake(imgWeibo.size.width, 30);
    UILabel* labelWeibo = [[UILabel alloc] initWithFrame:frame];
    labelWeibo.text = @"微博";
    labelWeibo.font = [UIFont systemFontOfSize:14];
    labelWeibo.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    labelWeibo.textAlignment = NSTextAlignmentCenter;
    [viewMain addSubview:labelWeibo];
    
    frame.origin = viewWechat.frame.origin;
    frame.size = CGSizeMake(imgWechat.size.width, imgWechat.size.height + labelWechat.frame.size.height);
    UIButton* buttonWechatLogin = [[UIButton alloc] initWithFrame:frame];
    [buttonWechatLogin addTarget:self action:@selector(wechatLogin) forControlEvents:UIControlEventTouchUpInside];
    [viewMain addSubview:buttonWechatLogin];
    
    frame.origin = viewWeibo.frame.origin;
    frame.size = CGSizeMake(imgWeibo.size.width, imgWeibo.size.height + labelWeibo.frame.size.height);
    UIButton* buttonWeiboLogin = [[UIButton alloc] initWithFrame:frame];
    [buttonWeiboLogin addTarget:self action:@selector(weiboLogin) forControlEvents:UIControlEventTouchUpInside];
    [viewMain addSubview:buttonWeiboLogin];
    
    [self.view addSubview:viewMain];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customGoBack) name:AppUserLoginNotification object:nil];
}

- (void)submitLogin
{
    BOOL bolValid = YES;
    if (fieldUsername.text.length < 2) {
        bolValid = NO;
        [APPNAVGATOR showAlert:@"帐号检查" Message:@"请输入正确的手机号"];
    }
    if (bolValid && fieldPassword.text.length < 1) {
        bolValid = NO;
        [APPNAVGATOR showAlert:@"帐号检查" Message:@"请输入正确的密码"];
    }
    if (bolValid)
    {
        if (nil != fieldCur)
        {
            [fieldCur resignFirstResponder];
        }
        [self showChrysanthemumHUD:YES];
        typeof(self) weakSelf = self;
        [LoginRequestManager postLogin:fieldUsername.text andPassword:fieldPassword.text success:^(id obj) {
            //获取用户信息去
            if(!USEROPERATIONHELP.currentUser)
            {
                AppUser* user = [[AppUser alloc] initWithDic:[obj objectForKey:@"memberinfo"]];
                USEROPERATIONHELP.currentUser = user;
                USEROPERATIONHELP.currentUser.isLogined = YES;
                [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:AppUserLoginNotification object:nil];
            }
            [weakSelf removeAllHUDViews:NO];
            [weakSelf customGoBack];
        } failed:^(id error) {
            [weakSelf removeAllHUDViews:NO];
            [weakSelf dealWithError:error];
        }];
    }
}



- (void)customGoBack
{
    [super customGoBack];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if(fieldPassword)
    {
        [fieldPassword setText:nil];
    }
}

- (void)goRegister
{
    RegisterViewController* vcRegister = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vcRegister animated:YES];
}

- (void)wechatLogin
{
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo,snsapi_base"; // @"post_timeline,sns"
    req.state = @"0744";
    req.openID = KWeixinAppKey;
    [WXApi sendAuthReq:req viewController:self delegate:APPDELEGATE];
}

-(void)webLogin:(NSNotification*)notificaiton
{
    NSDictionary* dic = notificaiton.object;
    __weak typeof(self) weakSelf = self;
    [self showChrysanthemumHUD:YES];
    NSString* userId = [dic objectForKey:@"uid"];
    NSString* token = [dic objectForKey:@"access_token"];

    [LoginRequestManager sendGetWeiboUserInfo:userId token:token success:^(id obj)
    {
        //微博登录成功
        [weakSelf removeAllHUDViews:NO];
    } failed:^(id error)
    {
        //微博登录失败
        [weakSelf removeAllHUDViews:NO];
        [weakSelf dealWithError:error];
    }];
}

- (void)weiboLogin
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)goResetPassword
{
    ResetPasswordViewController* vcResetPassword = [[ResetPasswordViewController alloc] init];
    [self.navigationController pushViewController:vcResetPassword animated:YES];
}

#pragma mark - TextField & Other Delegate
- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    fieldCur = textField;
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    fieldCur = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if (textField.returnKeyType == UIReturnKeyNext) {
        [fieldPassword becomeFirstResponder];
    }
    if (textField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
