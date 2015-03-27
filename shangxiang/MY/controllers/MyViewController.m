#import "MyViewController.h"
#import "UIImageView+WebCache.h"
#import "UserViewController.h"
#import "OrderRecordViewController.h"
#import "BrowserViewController.h"
#import "SettingsViewController.h"
#import "FeedbackViewController.h"
#import "LoginRequestManager.h"
#import "NotificationViewController.h"
#import "Reachability.h"
#import "BlessViewController.h"
#define TAG_ACTIONSHEET 523


@interface MyViewController ()<UIActionSheetDelegate>
{
    UIScrollView* _contentScollView;
    UILabel* _labelUsername;
    UIImageView* _viewAvatar;
    UIButton* buttonDiscoverTotalTome;
    UIButton* buttonDiscoverTotalToother;
}

@end

@implementation MyViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的";
    self.view.backgroundColor = UIColorFromRGB(COLOR_BG_NORMAL);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo:) name:AppUserLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo:) name:AppUserLogoutNotification object:nil];
    
    _contentScollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    _contentScollView.backgroundColor = UIColorFromRGB(COLOR_BG_NORMAL);
    _contentScollView.pagingEnabled = NO;
    _contentScollView.clipsToBounds = NO;
    _contentScollView.alwaysBounceHorizontal = NO;
    _contentScollView.showsVerticalScrollIndicator = YES;
    _contentScollView.showsHorizontalScrollIndicator = NO;
    [_contentScollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    
    CGRect frame = CGRectZero;
    float fltViewWidth = _contentScollView.width;
    float fltCellHeight = 44;
    float fltMargin = 20;
    float fltMinMargin = 10;
    float fltLabelWidth = 200;
    float fltBegin = 0;
    
    UIImage* imgArrow = [UIImage imageForKey:@"arrow_right"];
    UIImage* imgAvatar = [UIImage imageForKey:@"avatar_null"];
    
    float fltUserCellHeight = imgAvatar.size.height + fltMinMargin * 2;
    frame.origin = CGPointMake(0, fltBegin);
    frame.size = CGSizeMake(fltViewWidth, fltUserCellHeight);
    UIButton* buttonUser = [[UIButton alloc] initWithFrame:frame];
    [buttonUser setTag:0];
    [buttonUser setBackgroundColor:UIColorFromRGB(COLOR_BG_HIGHLIGHT)];
    [buttonUser addTarget:self action:@selector(goTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    frame.origin = CGPointMake(fltViewWidth - fltMinMargin - imgArrow.size.width, (fltUserCellHeight - imgArrow.size.height) / 2);
    frame.size = imgArrow.size;
    UIImageView* viewArrow = [[UIImageView alloc] initWithFrame:frame];
    viewArrow.image = imgArrow;
    [buttonUser addSubview:viewArrow];
    
    frame.origin = CGPointMake(fltMinMargin, fltMinMargin);
    frame.size = imgAvatar.size;
    _viewAvatar = [[UIImageView alloc] initWithFrame:frame];
    _viewAvatar.image = imgAvatar;
    _viewAvatar.layer.borderWidth = 1;
    _viewAvatar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewAvatar.clipsToBounds = YES;
    _viewAvatar.layer.cornerRadius = _viewAvatar.width/2;
    [buttonUser addSubview:_viewAvatar];
    
    frame.origin = CGPointMake(fltUserCellHeight, fltMinMargin);
    frame.size = CGSizeMake(fltLabelWidth, imgAvatar.size.height);
    _labelUsername = [[UILabel alloc] initWithFrame:frame];
    _labelUsername.text = @"请登录";
    _labelUsername.font = [UIFont systemFontOfSize:15];
    _labelUsername.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    [buttonUser addSubview:_labelUsername];
    
    [_contentScollView addSubview:buttonUser];

    fltBegin += fltUserCellHeight;
    
    float fltDiscoverTotalHeight = 40.0f;
    frame.origin = CGPointMake(0, fltBegin);
    frame.size = CGSizeMake(fltViewWidth, fltDiscoverTotalHeight);
    UIView* viewDiscover = [[UIView alloc] initWithFrame:frame];
    [viewDiscover setBackgroundColor:UIColorFromRGB(COLOR_BG_HIGHLIGHT)];
    
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc] initWithString:@"我的加持253"];
    [attributedText setAttributes:@{ NSForegroundColorAttributeName : UIColorFromRGB(COLOR_FONT_HIGHLIGHT)}
                            range:NSMakeRange(4, [attributedText length] - 4)];
    
    frame.origin = CGPointMake(0, 0);
    frame.size = CGSizeMake(fltViewWidth / 2 - 1, fltDiscoverTotalHeight - 5);
    buttonDiscoverTotalTome = [[UIButton alloc] initWithFrame:frame];
    [buttonDiscoverTotalTome setTag:1];
    [buttonDiscoverTotalTome setAttributedTitle:attributedText forState:UIControlStateNormal];
    [buttonDiscoverTotalTome setTitleColor:UIColorFromRGB(COLOR_FONT_NORMAL) forState:UIControlStateNormal];
    [buttonDiscoverTotalTome.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [buttonDiscoverTotalTome setBackgroundColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_GRAY)];
    [buttonDiscoverTotalTome addTarget:self action:@selector(goTarget:) forControlEvents:UIControlEventTouchUpInside];
    [viewDiscover addSubview:buttonDiscoverTotalTome];
    
    attributedText = [[NSMutableAttributedString alloc] initWithString:@"为我加持152"];
    [attributedText setAttributes:@{ NSForegroundColorAttributeName : UIColorFromRGB(COLOR_FONT_HIGHLIGHT) }
                            range:NSMakeRange(4, [attributedText length] - 4)];
    
    frame.origin = CGPointMake(fltViewWidth / 2 + 1, 0);
    frame.size = CGSizeMake(fltViewWidth / 2 - 1, fltDiscoverTotalHeight - 5);
    buttonDiscoverTotalToother = [[UIButton alloc] initWithFrame:frame];
    [buttonDiscoverTotalToother setTag:2];
    [buttonDiscoverTotalToother setAttributedTitle:attributedText forState:UIControlStateNormal];
    [buttonDiscoverTotalToother setTitleColor:UIColorFromRGB(COLOR_FONT_NORMAL) forState:UIControlStateNormal];
    [buttonDiscoverTotalToother.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [buttonDiscoverTotalToother setBackgroundColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_GRAY)];
    [buttonDiscoverTotalToother addTarget:self action:@selector(goTarget:) forControlEvents:UIControlEventTouchUpInside];
    [viewDiscover addSubview:buttonDiscoverTotalToother];
    
    frame.origin = CGPointMake(0, fltDiscoverTotalHeight);
    frame.size = CGSizeMake(fltViewWidth, HEIGHT_LINE);
    UIView* viewTemp = [[UIView alloc] initWithFrame:frame];
    viewTemp.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
    [viewDiscover addSubview:viewTemp];
    
    [_contentScollView addSubview:viewDiscover];
    
    fltBegin += fltDiscoverTotalHeight + 20;
    
    frame.origin = CGPointMake(0, fltBegin);
    frame.size = CGSizeMake(fltViewWidth, fltCellHeight);
    UIButton* buttonOrderRecord = [[UIButton alloc] initWithFrame:frame];
    [buttonOrderRecord setTag:3];
    [buttonOrderRecord setBackgroundColor:UIColorFromRGB(COLOR_BG_HIGHLIGHT)];
    [buttonOrderRecord addTarget:self action:@selector(goTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    frame.origin = CGPointMake(0, 0);
    frame.size = CGSizeMake(fltViewWidth, HEIGHT_LINE);
    viewTemp = [[UIView alloc] initWithFrame:frame];
    viewTemp.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
    [buttonOrderRecord addSubview:viewTemp];
    
    frame.origin = CGPointMake(0, fltCellHeight);
    frame.size = CGSizeMake(fltViewWidth, HEIGHT_LINE);
    viewTemp = [[UIView alloc] initWithFrame:frame];
    viewTemp.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
    [buttonOrderRecord addSubview:viewTemp];
    
    frame.origin = CGPointMake(fltViewWidth - fltMinMargin - imgArrow.size.width, (fltCellHeight - imgArrow.size.height) / 2);
    frame.size = imgArrow.size;
    viewArrow = [[UIImageView alloc] initWithFrame:frame];
    viewArrow.image = imgArrow;
    [buttonOrderRecord addSubview:viewArrow];
    
    frame.origin = CGPointMake(fltMargin, 0);
    frame.size = CGSizeMake(fltLabelWidth, fltCellHeight);
    UILabel* labelOrderRecord = [[UILabel alloc] initWithFrame:frame];
    labelOrderRecord.text = @"订单查询";
    labelOrderRecord.font = [UIFont systemFontOfSize:15];
    labelOrderRecord.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    [buttonOrderRecord addSubview:labelOrderRecord];
    
    [_contentScollView addSubview:buttonOrderRecord];
    
    fltBegin += fltCellHeight + 20;
    
    frame.origin = CGPointMake(0, fltBegin);
    frame.size = CGSizeMake(fltViewWidth, fltCellHeight);
    UIButton* buttonNotice = [[UIButton alloc] initWithFrame:frame];
    [buttonNotice setTag:4];
    [buttonNotice setBackgroundColor:UIColorFromRGB(COLOR_BG_HIGHLIGHT)];
    [buttonNotice addTarget:self action:@selector(goTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    frame.origin = CGPointMake(0, 0);
    frame.size = CGSizeMake(fltViewWidth, HEIGHT_LINE);
    viewTemp = [[UIView alloc] initWithFrame:frame];
    viewTemp.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
    [buttonNotice addSubview:viewTemp];
    
    frame.origin = CGPointMake(fltViewWidth - fltMinMargin - imgArrow.size.width, (fltCellHeight - imgArrow.size.height) / 2);
    frame.size = imgArrow.size;
    viewArrow = [[UIImageView alloc] initWithFrame:frame];
    viewArrow.image = imgArrow;
    [buttonNotice addSubview:viewArrow];
    
    frame.origin = CGPointMake(fltMargin, 0);
    frame.size = CGSizeMake(fltLabelWidth, fltCellHeight);
    UILabel* labelNotice = [[UILabel alloc] initWithFrame:frame];
    labelNotice.text = @"系统通知";
    labelNotice.font = [UIFont systemFontOfSize:15];
    labelNotice.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    [buttonNotice addSubview:labelNotice];
    
    [_contentScollView addSubview:buttonNotice];
    
    fltBegin += fltCellHeight;
    
    frame.origin = CGPointMake(0, fltBegin);
    frame.size = CGSizeMake(fltViewWidth, fltCellHeight);
    UIButton* buttonAlertSetting = [[UIButton alloc] initWithFrame:frame];
    [buttonAlertSetting setTag:5];
    [buttonAlertSetting setBackgroundColor:UIColorFromRGB(COLOR_BG_HIGHLIGHT)];
    [buttonAlertSetting addTarget:self action:@selector(goTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    frame.origin = CGPointMake(0, 0);
    frame.size = CGSizeMake(fltViewWidth, HEIGHT_LINE);
    viewTemp = [[UIView alloc] initWithFrame:frame];
    viewTemp.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
    [buttonAlertSetting addSubview:viewTemp];
    
    frame.origin = CGPointMake(fltViewWidth - fltMinMargin - imgArrow.size.width, (fltCellHeight - imgArrow.size.height) / 2);
    frame.size = imgArrow.size;
    viewArrow = [[UIImageView alloc] initWithFrame:frame];
    viewArrow.image = imgArrow;
    [buttonAlertSetting addSubview:viewArrow];
    
    frame.origin = CGPointMake(fltMargin, 0);
    frame.size = CGSizeMake(fltLabelWidth, fltCellHeight);
    UILabel* labelAlermSetting = [[UILabel alloc] initWithFrame:frame];
    labelAlermSetting.text = @"设置";
    labelAlermSetting.font = [UIFont systemFontOfSize:15];
    labelAlermSetting.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    [buttonAlertSetting addSubview:labelAlermSetting];
    
    [_contentScollView addSubview:buttonAlertSetting];
    
    fltBegin += fltCellHeight;
    
    frame.origin = CGPointMake(0, fltBegin);
    frame.size = CGSizeMake(fltViewWidth, fltCellHeight);
    UIButton* buttonRate = [[UIButton alloc] initWithFrame:frame];
    [buttonRate setTag:6];
    [buttonRate setBackgroundColor:UIColorFromRGB(COLOR_BG_HIGHLIGHT)];
    [buttonRate addTarget:self action:@selector(goTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    frame.origin = CGPointMake(0, 0);
    frame.size = CGSizeMake(fltViewWidth, HEIGHT_LINE);
    viewTemp = [[UIView alloc] initWithFrame:frame];
    viewTemp.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
    [buttonRate addSubview:viewTemp];
    
    frame.origin = CGPointMake(fltViewWidth - fltMinMargin - imgArrow.size.width, (fltCellHeight - imgArrow.size.height) / 2);
    frame.size = imgArrow.size;
    viewArrow = [[UIImageView alloc] initWithFrame:frame];
    viewArrow.image = imgArrow;
    [buttonRate addSubview:viewArrow];
    
    frame.origin = CGPointMake(fltMargin, 0);
    frame.size = CGSizeMake(fltLabelWidth, fltCellHeight);
    UILabel* labelRate = [[UILabel alloc] initWithFrame:frame];
    labelRate.text = @"支持一下";
    labelRate.font = [UIFont systemFontOfSize:15];
    labelRate.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    [buttonRate addSubview:labelRate];
    
    [_contentScollView addSubview:buttonRate];
    
    fltBegin += fltCellHeight;
    
    frame.origin = CGPointMake(0, fltBegin);
    frame.size = CGSizeMake(fltViewWidth, fltCellHeight);
    UIButton* buttonFeedback = [[UIButton alloc] initWithFrame:frame];
    [buttonFeedback setTag:7];
    [buttonFeedback setBackgroundColor:UIColorFromRGB(COLOR_BG_HIGHLIGHT)];
    [buttonFeedback addTarget:self action:@selector(goTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    frame.origin = CGPointMake(0, 0);
    frame.size = CGSizeMake(fltViewWidth, HEIGHT_LINE);
    viewTemp = [[UIView alloc] initWithFrame:frame];
    viewTemp.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
    [buttonFeedback addSubview:viewTemp];
    
    frame.origin = CGPointMake(fltViewWidth - fltMinMargin - imgArrow.size.width, (fltCellHeight - imgArrow.size.height) / 2);
    frame.size = imgArrow.size;
    viewArrow = [[UIImageView alloc] initWithFrame:frame];
    viewArrow.image = imgArrow;
    [buttonFeedback addSubview:viewArrow];
    
    frame.origin = CGPointMake(fltMargin, 0);
    frame.size = CGSizeMake(fltLabelWidth, fltCellHeight);
    UILabel* labelFeedback = [[UILabel alloc] initWithFrame:frame];
    labelFeedback.text = @"意见反馈";
    labelFeedback.font = [UIFont systemFontOfSize:15];
    labelFeedback.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    [buttonFeedback addSubview:labelFeedback];
    
    [_contentScollView addSubview:buttonFeedback];
    
    fltBegin += fltCellHeight;
    
    frame.origin = CGPointMake(0, fltBegin);
    frame.size = CGSizeMake(fltViewWidth, fltCellHeight);
    UIButton* buttonAbout = [[UIButton alloc] initWithFrame:frame];
    [buttonAbout setTag:8];
    [buttonAbout setBackgroundColor:UIColorFromRGB(COLOR_BG_HIGHLIGHT)];
    [buttonAbout addTarget:self action:@selector(goTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    frame.origin = CGPointMake(0, 0);
    frame.size = CGSizeMake(fltViewWidth, HEIGHT_LINE);
    viewTemp = [[UIView alloc] initWithFrame:frame];
    viewTemp.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
    [buttonAbout addSubview:viewTemp];
    
    frame.origin = CGPointMake(0, fltCellHeight);
    frame.size = CGSizeMake(fltViewWidth, HEIGHT_LINE);
    viewTemp = [[UIView alloc] initWithFrame:frame];
    viewTemp.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
    [buttonAbout addSubview:viewTemp];
    
    frame.origin = CGPointMake(fltViewWidth - fltMinMargin - imgArrow.size.width, (fltCellHeight - imgArrow.size.height) / 2);
    frame.size = imgArrow.size;
    viewArrow = [[UIImageView alloc] initWithFrame:frame];
    viewArrow.image = imgArrow;
    [buttonAbout addSubview:viewArrow];
    
    frame.origin = CGPointMake(fltMargin, 0);
    frame.size = CGSizeMake(fltLabelWidth, fltCellHeight);
    UILabel* labelAbout = [[UILabel alloc] initWithFrame:frame];
    labelAbout.text = @"关于我们";
    labelAbout.font = [UIFont systemFontOfSize:15];
    labelAbout.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    [buttonAbout addSubview:labelAbout];
    
//    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(-1, buttonAbout.bottom, self.view.width + 2, 44)];
//    button.backgroundColor = UIColorFromRGB(COLOR_BG_HIGHLIGHT);
//    button.layer.borderColor = UIColorFromRGB(COLOR_LINE_NORMAL).CGColor;
//    button.layer.borderWidth = 0.5;
//    [button setTitle:@"退出登录" forState:UIControlStateNormal];
//    [button setTitleColor:UIColorFromRGB(COLOR_FONT_NORMAL) forState:UIControlStateNormal];
//    [button setTitleColor:UIColorFromRGB(COLOR_FONT_HIGHLIGHT) forState:UIControlStateHighlighted];
//    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
//    [_contentScollView addSubview:button];
    
    _contentScollView.contentSize = CGSizeMake(fltViewWidth, fltBegin + fltCellHeight);
    _contentScollView.contentOffset = CGPointMake(0, 0);
    [_contentScollView addSubview:buttonAbout];

    [self.view addSubview:_contentScollView];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(USEROPERATIONHELP.isLogin && [[Reachability reachabilityWithHostName:@"www.shangxiang.com"] currentReachabilityStatus] != kNotReachable)
    {
        __weak typeof(self) weakSelf = self;
        [LoginRequestManager sendGetUserInfo:USEROPERATIONHELP.currentUser.userId success:^(id obj) {
            [weakSelf updateUserInfo:nil];
        } failed:^(id error) {
        }];
    }
    else
    {
        [self updateUserInfo:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_contentScollView setContentSize:CGSizeMake(_contentScollView.width,_contentScollView.height + 20)];
}


//退出登录
- (void)buttonClicked
{
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"退出登录",nil];
    actionsheet.tag = TAG_ACTIONSHEET;
    [actionsheet showInView:APPDELEGATE.window];
}

#pragma mark SheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet.tag == TAG_ACTIONSHEET && buttonIndex == 0)
    {
        USEROPERATIONHELP.currentUser.isLogined = NO;
        [UserGlobalSetting setCurrentUser:nil];
        USEROPERATIONHELP.currentUser = nil;
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:AppUserLogoutNotification object:nil];
    }
}


#pragma mark - Do action
- (void)goTarget:(UIButton*)button
{
    BaseViewController* vcTarget;
    switch (button.tag)
    {
        case 0:
        {
            if([[Reachability reachabilityWithHostName:@"www.shangxiang.com"] currentReachabilityStatus] == kNotReachable)
            {
                [self showTimedHUD:YES message:@"当前无网络连接，请检查您的网络"];
                return;
            }
            else if(USEROPERATIONHELP.isLogin)
            {
                vcTarget = [[UserViewController alloc] init];
            }
            else
            {
                [APPNAVGATOR turnToLoginGuide];
                return;
            }
        }
            break;
        case 1:
        {
            if([[Reachability reachabilityWithHostName:@"www.shangxiang.com"] currentReachabilityStatus] == kNotReachable)
            {
                [self showTimedHUD:YES message:@"当前无网络连接，请检查您的网络"];
                return;
            }
            else if(USEROPERATIONHELP.isLogin)
            {
                vcTarget = [[BlessViewController alloc] init];
                ((BlessViewController*)vcTarget).index = 0;
            }
            else
            {
                [APPNAVGATOR turnToLoginGuide];
                return;
            }
        }
            break;
        case 2:
        {
            if([[Reachability reachabilityWithHostName:@"www.shangxiang.com"] currentReachabilityStatus] == kNotReachable)
            {
                [self showTimedHUD:YES message:@"当前无网络连接，请检查您的网络"];
                return;
            }
            else if(USEROPERATIONHELP.isLogin)
            {
                vcTarget = [[BlessViewController alloc] init];
                 ((BlessViewController*)vcTarget).index = 1;
            }
            else
            {
                [APPNAVGATOR turnToLoginGuide];
                return;
            }
        }
            break;
        case 3:
        {
            if([[Reachability reachabilityWithHostName:@"www.shangxiang.com"] currentReachabilityStatus] == kNotReachable)
            {
                [self showTimedHUD:YES message:@"当前无网络连接，请检查您的网络"];
                return;
            }
            else if(USEROPERATIONHELP.isLogin)
            {
                vcTarget = [[OrderRecordViewController alloc] init];
            }
            else
            {
                [APPNAVGATOR turnToLoginGuide];
                return;
            }
        }
            break;
        case 4:
        {
            if([[Reachability reachabilityWithHostName:@"www.shangxiang.com"] currentReachabilityStatus] == kNotReachable)
            {
                [self showTimedHUD:YES message:@"当前无网络连接，请检查您的网络"];
                return;
            }
            else
            {
                vcTarget = [[NotificationViewController alloc] init];
            }
            
//            vcTarget = [[BrowserViewController alloc] init];
//            ((BrowserViewController*)vcTarget).url = @"http://www.shangxiang.com";
        }
            break;
        case 5:
        {
            if([[Reachability reachabilityWithHostName:@"www.shangxiang.com"] currentReachabilityStatus] == kNotReachable)
            {
                [self showTimedHUD:YES message:@"当前无网络连接，请检查您的网络"];
                return;
            }
            else if(USEROPERATIONHELP.isLogin)
            {
                vcTarget = [[SettingsViewController alloc] init];
            }
            else
            {
                [APPNAVGATOR turnToLoginGuide];
                return;
            }
        }
            break;
        case 7:
        {
            if([[Reachability reachabilityWithHostName:@"www.shangxiang.com"] currentReachabilityStatus] == kNotReachable)
            {
                [self showTimedHUD:YES message:@"当前无网络连接，请检查您的网络"];
                return;
            }
            else if(USEROPERATIONHELP.isLogin)
            {
                vcTarget = [[FeedbackViewController alloc] init];
            }
            else
            {
                [APPNAVGATOR turnToLoginGuide];
                return;
            }
        }
            break;
        case 8:
        {
            if([[Reachability reachabilityWithHostName:@"www.shangxiang.com"] currentReachabilityStatus] == kNotReachable)
            {
                [self showTimedHUD:YES message:@"当前无网络连接，请检查您的网络"];
                return;
            }
            else
            {
                vcTarget = [[BrowserViewController alloc] init];
                ((BrowserViewController*)vcTarget).url = @"http://app.shangxiang.com/app_aboutus.html";
            }
        }
            break;
        default:
            vcTarget = nil;
            break;
    }
    if (nil != vcTarget)
    {
        [self.navigationController pushViewController:vcTarget animated:YES];
    }
}


- (void)updateUserInfo:(NSNotification*)notification
{
    if(USEROPERATIONHELP.isLogin)
    {
        _labelUsername.text = [LUtility getShowName];
        
        [_viewAvatar sd_setImageWithURL:[NSURL URLWithString:USEROPERATIONHELP.currentUser.headUrl] placeholderImage:[UIImage imageForKey:@"avatar_null"]];
        
        NSString* blessing = USEROPERATIONHELP.currentUser.doBlessings > 0 ? [NSString stringWithFormat:@"我的加持%zd",USEROPERATIONHELP.currentUser.doBlessings] : @"我的加持";
        
        NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc] initWithString:blessing];
        [attributedText setAttributes:@{ NSForegroundColorAttributeName : UIColorFromRGB(COLOR_FONT_HIGHLIGHT)}
                                range:NSMakeRange(4, [attributedText length] - 4)];
        [buttonDiscoverTotalTome setAttributedTitle:attributedText forState:UIControlStateNormal];
        
        
        blessing = USEROPERATIONHELP.currentUser.receivedBlessings > 0 ? [NSString stringWithFormat:@"为我加持%zd",USEROPERATIONHELP.currentUser.receivedBlessings] : @"为我加持";
        attributedText = [[NSMutableAttributedString alloc] initWithString:blessing];
        [attributedText setAttributes:@{ NSForegroundColorAttributeName : UIColorFromRGB(COLOR_FONT_HIGHLIGHT) }
                                range:NSMakeRange(4, [attributedText length] - 4)];
        [buttonDiscoverTotalToother setAttributedTitle:attributedText forState:UIControlStateNormal];
        
    }
    else
    {
        _labelUsername.text = @"登录";
        [_viewAvatar setImage:[UIImage imageForKey:@"avatar_null"]];
        NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我的加持"]];
        [buttonDiscoverTotalTome setAttributedTitle:attributedText forState:UIControlStateNormal];
        
        attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"为我加持"]];
        [buttonDiscoverTotalToother setAttributedTitle:attributedText forState:UIControlStateNormal];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end