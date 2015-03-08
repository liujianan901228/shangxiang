//
//  RootNavigationViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "RootNavigationViewController.h"
#import "AddBirthdayViewController.h"
#import "editRemindViewController.h"

@interface RootNavigationViewController ()

@end

@implementation RootNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setUpNavigationBar];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpNavigationBar];
    }
    return self;
}

-(void)setUpNavigationBar
{
    UIImage* bgImage = [UIImage imageWithColor:UIColorFromRGB(COLOR_NAV_BAR)];
    if (kScreenWidth > 320)
    {
        bgImage = [bgImage imageByResizeToSize:CGSizeMake(kScreenWidth, bgImage.size.height)];
    }
    [self.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTintColor:UIColorFromRGB(COLOR_NAV_BAR)];
    [self.navigationBar setBarTintColor:UIColorFromRGB(COLOR_NAV_BAR)];
    [self.navigationBar setBackgroundColor:UIColorFromRGB(COLOR_NAV_BAR)];
    [self.navigationBar setTranslucent:NO];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(COLOR_FONT_HIGHLIGHT), NSForegroundColorAttributeName, nil]];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{    
    if([viewController isKindOfClass:[AddBirthdayViewController class]] || [viewController isKindOfClass:[editRemindViewController class]])
    {
        [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:240./256. green:240./256. blue:240./256. alpha:1]] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        UIImage* bgImage = [UIImage imageWithColor:UIColorFromRGB(COLOR_NAV_BAR)];
        if (kScreenWidth > 320)
        {
            bgImage = [bgImage imageByResizeToSize:CGSizeMake(kScreenWidth, bgImage.size.height)];
        }
        [self.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    }
    
    if (self.viewControllers.count)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

//ios6以上
- (NSUInteger)supportedInterfaceOrientations{
    return _isRotate ? UIInterfaceOrientationMaskAllButUpsideDown : UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return _isRotate;
}



@end
