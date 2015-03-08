//
//  BaseTableViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UIBarButtonItem+Image.h"

@interface BaseTableViewController ()
@property(nonatomic,strong)UIImageView* backgroundImageView;
@end

@implementation BaseTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}


+ (UIBarButtonItem *)navigationBackButtonItemWithTarget:(id)target action:(SEL)action
{
    UIImage         *normalImage = [UIImage imageForKey:@"titlebar_back"];
    UIBarButtonItem *buttonItem = [UIBarButtonItem rsBarButtonItemWithTitle:nil
                                                                      image:normalImage
                                                           heightLightImage:nil
                                                               disableImage:nil
                                                                     target:target
                                                                     action:action];
    
    return buttonItem;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeTop;
    }
    self.tableView.backgroundColor = [UIColor colorWithRed:244/255.0 green:246/255.0 blue:240/255.0 alpha:1.0];
    
    // 导航栏
    self.navigationController.navigationBarHidden = NO;
    
    // 返回按钮
    NSInteger x = [self.navigationController.viewControllers count];
    
    if (x > 1)
    {
        // 多余一级的时候，再创建返回按钮
        [self setLeftBarButtonItem:[BaseTableViewController navigationBackButtonItemWithTarget:self action:@selector(goBack)]];
    }
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

#pragma mark HUD相关
- (void)showTimedHUD:(BOOL)animated message:(NSString *)message
{
    [self removeAllHUDViews:animated];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.margin = 10.f;
    hud.yOffset = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:animated];
    [hud hide:animated afterDelay:1.3];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
