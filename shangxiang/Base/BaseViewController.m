//
//  BaseViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "BaseViewController.h"
#import "UIBarButtonItem+Image.h"

@interface BaseViewController ()
@property(nonatomic,strong)UIImageView* backgroundImageView;
@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeTop;
    }
    // 背景色
    self.view.backgroundColor = RGBCOLOR(0xfb, 0xfc, 0xfd);
    
    // 导航栏
    self.navigationController.navigationBarHidden = NO;
    

    // 返回按钮
    NSInteger x = [self.navigationController.viewControllers count];
    
    if (x > 1)
    {
        // 多余一级的时候，再创建返回按钮
        [self setLeftBarButtonItem:[BaseViewController navigationBackButtonItemWithTarget:self action:@selector(goBack)]];
    }
}


-(void)setBackBarButtonItem
{
    [self setLeftBarButtonItem:[BaseViewController navigationBackButtonItemWithTarget:self action:@selector(customGoBack)]];
}


-(void)customGoBack
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    if (!barButtonItem) {
        if ([self.navigationController.viewControllers count] > 1) {
            self.navigationItem.hidesBackButton = YES;
        }
        self.navigationItem.leftBarButtonItems = nil;
        return;
    }
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    // ios7适配
    if ([LUtility isHigherIOS7]) {
        negativeSpacer.width = -5;
    } else {
        negativeSpacer.width = 15;
    }
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, barButtonItem, nil];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    // ios7适配
    if ([LUtility isHigherIOS7]) {
        negativeSpacer.width = -5;
    } else {
        negativeSpacer.width = 15;
    }
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, barButtonItem, nil];
}

+ (UIBarButtonItem *)navigationBackButtonItemWithTarget:(id)target action:(SEL)action
{
    UIImage         *normalImage = [UIImage imageForKey:@"button_back"];
    UIBarButtonItem *buttonItem = [UIBarButtonItem rsBarButtonItemWithTitle:nil
                                                                      image:normalImage
                                                           heightLightImage:nil
                                                               disableImage:nil
                                                                     target:target
                                                                     action:action];
    
    return buttonItem;
}


#pragma mark HUD相关
- (void)showTimedHUD:(BOOL)animated message:(NSString *)message
{
    [self removeAllHUDViews:animated];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.cornerRadius = 2.5f;
    hud.yOffset = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:animated];
    [hud hide:animated afterDelay:1.3];
}

- (void)showTimedHUD:(BOOL)animated message:(NSString *)message hideAfter:(NSTimeInterval)time {
    [self removeAllHUDViews:animated];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.margin = 10.f;
    hud.yOffset = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:animated];
    [hud hide:animated afterDelay:time];
}

- (void)showChrysanthemumHUD:(BOOL)animated yOffset:(CGFloat)yOffset height:(CGFloat)height
{
    [self removeAllHUDViews:animated];
    
    CGRect hudFrame = self.view.bounds;
    hudFrame.origin.y += yOffset;
    hudFrame.size.height = height;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:hudFrame];
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:animated];
}

- (void)showChrysanthemumHUD:(BOOL)animated
{
    [self showChrysanthemumHUD:animated yOffset:0 height:self.view.height];
}

- (void)removeAllHUDViews:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:animated];
}

- (void)goBack
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    if (1 < viewControllers.count && self == [viewControllers lastObject]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//  ios6以下
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

// ios6以上
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

-(void)unLoadViews
{
    //For subClass
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidLoad
    if (![self isViewLoaded]) {
        return;
    }
    if ([[UIDevice currentDevice] systemVersion].floatValue > 6.0f) {
        if (self.view.window == nil) { // 是否是正在使用的视图
            [self unLoadViews];
            self.view = nil;
        }
    }
}

- (void)dealWithError:(ExError*)error
{
    [self showTimedHUD:YES message:error.titleForError];
}


@end
